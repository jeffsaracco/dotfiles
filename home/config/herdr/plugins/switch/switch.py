"""Workspace switcher for herdr, like tmux's choose-tree (prefix+s).

`open` launches the popup pane; `ui` runs inside it. Focusing a workspace
lands on whichever tab it was last left on.

Workspaces on enabled saved SSH machines are listed too. herdr's API can't
switch the TUI to another machine (that state lives in the client), so picking
a remote workspace types the keys you would: prefix+w to focus the machines
sidebar, arrows to the row, enter. The keys go to the focused Ghostty terminal
as raw bytes through its AppleScript `perform action` (synthetic `send key`
events never register as ctrl+b). This assumes the sidebar's arrow keys step
through every machine's spaces in order (machine headers aren't selectable),
starting on the focused space.

`last-tab` jumps back to the previously focused tab in the current
workspace, like tmux's last-window; `event` records per-workspace tab
history from pane.focused hooks.
"""

import json
import os
import select
import subprocess
import sys
import termios
import tty

PICKER_ENTRYPOINT = "picker"
REMOTE_TIMEOUT_SECONDS = 3
# Ghostty keybind actions writing each key's bytes to the terminal. The prefix
# must match keys.prefix in config.toml (unset = herdr's default ctrl+b).
PREFIX_ACTION = "text:\\x02"
OPEN_SIDEBAR_ACTION = "text:w"
DOWN_ACTION = "csi:B"
UP_ACTION = "csi:A"
ENTER_ACTION = "text:\\r"
# Lets the popup close before keys arrive, so they reach the herdr client.
SEND_KEYS_DELAY_SECONDS = 0.3


def herdr(*args):
    out = subprocess.run(["herdr", *args], check=True, capture_output=True, text=True)
    return json.loads(out.stdout) if out.stdout.strip() else None


def list_machines():
    """Returns [{label, id, selected, workspaces}] in sidebar order: local
    (id None) first, then enabled SSH machines. An unreachable machine has no
    workspaces."""
    try:
        saved = [m for m in herdr("machine", "list", "--json") or [] if m["enabled"]]
    except (subprocess.CalledProcessError, ValueError):
        saved = []
    # Query remotes concurrently; each is an SSH round trip.
    procs = [subprocess.Popen(
        ["herdr", "--machine", m["id"], "workspace", "list"],
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
        for m in saved]
    machines = [{"label": "local", "id": None,
                 "selected": not any(m["selected"] for m in saved),
                 "workspaces": herdr("workspace", "list")["result"]["workspaces"]}]
    for m, proc in zip(saved, procs):
        try:
            out, _ = proc.communicate(timeout=REMOTE_TIMEOUT_SECONDS)
            workspaces = json.loads(out)["result"]["workspaces"]
        except (subprocess.TimeoutExpired, ValueError, KeyError):
            proc.kill()
            workspaces = []
        machines.append({"label": m["label"], "id": m["id"],
                         "selected": m["selected"], "workspaces": workspaces})
    return machines


def switch_machine(delta):
    """Moves the sidebar cursor `delta` spaces from the focused one and enters."""
    actions = ([PREFIX_ACTION, OPEN_SIDEBAR_ACTION]
               + [DOWN_ACTION if delta > 0 else UP_ACTION] * abs(delta)
               + [ENTER_ACTION])
    lines = (['tell application "Ghostty"',
              "set t to focused terminal of selected tab of front window"]
             + ['perform action "%s" on t' % a.replace("\\", "\\\\") for a in actions]
             + ["end tell"])
    # Detached so it outlives the popup, whose closing returns focus to the TUI.
    subprocess.Popen(
        ["sh", "-c", 'sleep "$0"; exec osascript "$@"', str(SEND_KEYS_DELAY_SECONDS),
         *[arg for line in lines for arg in ("-e", line)]],
        start_new_session=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def open_popup():
    subprocess.run(
        ["herdr", "plugin", "pane", "open", "--plugin", os.environ["HERDR_PLUGIN_ID"],
         "--entrypoint", PICKER_ENTRYPOINT, "--focus"],
        capture_output=True,
    )


def read_key(fd):
    key = os.read(fd, 1)
    if key != b"\x1b":
        return key
    # Arrow keys arrive as ESC [ A/B; a lone ESC has nothing following.
    if not select.select([fd], [], [], 0.03)[0]:
        return key
    return key + os.read(fd, 2)


def draw(machines, selected):
    lines = []
    i = 0
    for m in machines:
        if len(machines) > 1:
            lines.append(f"\x1b[1m{m['label']}\x1b[0m")
        for ws in m["workspaces"]:
            marker = "*" if ws["focused"] else " "
            row = f" {ws['number']:>2} {marker} {ws['label']}"
            lines.append(f"\x1b[7m{row}\x1b[K\x1b[0m" if i == selected else row)
            i += 1
    sys.stdout.write("\x1b[H\x1b[2J" + "\r\n".join(lines))
    sys.stdout.flush()


def run_ui():
    machines = list_machines()
    entries = [(m["id"], ws) for m in machines for ws in m["workspaces"]]
    if not entries:
        return
    # entries is in sidebar order, so index distance is the arrow-key distance.
    current = next(m for m in machines if m["selected"])
    start = next((i for i, (machine_id, ws) in enumerate(entries)
                  if machine_id == current["id"] and ws["focused"]), 0)
    selected = start

    fd = sys.stdin.fileno()
    saved = termios.tcgetattr(fd)
    sys.stdout.write("\x1b[?25l")
    choice = None
    try:
        tty.setraw(fd)
        while True:
            draw(machines, selected)
            key = read_key(fd)
            if key in (b"j", b"\x1b[B", b"\x0e"):
                selected = (selected + 1) % len(entries)
            elif key in (b"k", b"\x1b[A", b"\x10"):
                selected = (selected - 1) % len(entries)
            elif key in (b"\r", b"\n"):
                choice = entries[selected]
                break
            elif key in (b"q", b"\x1b", b"\x03"):
                break
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, saved)
        sys.stdout.write("\x1b[?25h")
        sys.stdout.flush()

    if choice:
        machine_id, ws = choice
        if machine_id == current["id"]:
            machine = ["--machine", machine_id] if machine_id else []
            herdr(*machine, "workspace", "focus", ws["workspace_id"])
        else:
            switch_machine(selected - start)


def tab_history_path():
    state_dir = os.environ["HERDR_PLUGIN_STATE_DIR"]
    os.makedirs(state_dir, exist_ok=True)
    return os.path.join(state_dir, "tabs.json")


def load_tab_history():
    """Maps workspace_id -> {"current": tab_id, "previous": tab_id}."""
    try:
        with open(tab_history_path()) as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def save_tab_history(history):
    with open(tab_history_path(), "w") as f:
        json.dump(history, f)


def record_focus():
    payload = json.loads(os.environ.get("HERDR_PLUGIN_EVENT_JSON") or "{}")
    pane_id = payload.get("data", payload).get("pane_id")
    if not pane_id:
        return
    pane = herdr("pane", "get", pane_id)["result"]["pane"]
    history = load_tab_history()
    tabs = history.get(pane["workspace_id"], {})
    if pane["tab_id"] != tabs.get("current"):
        history[pane["workspace_id"]] = {
            "current": pane["tab_id"], "previous": tabs.get("current")}
        save_tab_history(history)


def last_tab():
    workspaces = herdr("workspace", "list")["result"]["workspaces"]
    focused = next((ws["workspace_id"] for ws in workspaces if ws["focused"]), None)
    previous = load_tab_history().get(focused, {}).get("previous")
    if previous:
        # A closed tab fails to focus; there is nothing better to go back to.
        subprocess.run(["herdr", "tab", "focus", previous], capture_output=True)


if __name__ == "__main__":
    {"open": open_popup, "ui": run_ui, "event": record_focus,
     "last-tab": last_tab}[sys.argv[1]]()
