"""Workspace switcher for herdr, like tmux's choose-tree (prefix+s).

`open` launches the popup pane; `ui` runs inside it. Focusing a workspace
lands on whichever tab it was last left on.

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


def herdr(*args):
    out = subprocess.run(["herdr", *args], check=True, capture_output=True, text=True)
    return json.loads(out.stdout) if out.stdout.strip() else None


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


def draw(workspaces, selected):
    lines = []
    for i, ws in enumerate(workspaces):
        marker = "*" if ws["focused"] else " "
        row = f" {ws['number']:>2} {marker} {ws['label']}"
        lines.append(f"\x1b[7m{row}\x1b[K\x1b[0m" if i == selected else row)
    sys.stdout.write("\x1b[H\x1b[2J" + "\r\n".join(lines))
    sys.stdout.flush()


def run_ui():
    workspaces = herdr("workspace", "list")["result"]["workspaces"]
    if not workspaces:
        return
    selected = next((i for i, ws in enumerate(workspaces) if ws["focused"]), 0)

    fd = sys.stdin.fileno()
    saved = termios.tcgetattr(fd)
    sys.stdout.write("\x1b[?25l")
    choice = None
    try:
        tty.setraw(fd)
        while True:
            draw(workspaces, selected)
            key = read_key(fd)
            if key in (b"j", b"\x1b[B", b"\x0e"):
                selected = (selected + 1) % len(workspaces)
            elif key in (b"k", b"\x1b[A", b"\x10"):
                selected = (selected - 1) % len(workspaces)
            elif key in (b"\r", b"\n"):
                choice = workspaces[selected]["workspace_id"]
                break
            elif key in (b"q", b"\x1b", b"\x03"):
                break
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, saved)
        sys.stdout.write("\x1b[?25h")
        sys.stdout.flush()

    if choice:
        herdr("workspace", "focus", choice)


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
