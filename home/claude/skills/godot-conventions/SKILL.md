---
name: godot-conventions
description: Jeff's conventions and hard-won gotchas for Godot 4.x projects in typed GDScript — scene/node composition, PNG art over _draw/StyleBoxFlat, Resources for data, headless testing (synchronous tests, tween custom_step, SceneTree -s scripts), controller/focus input quirks, safe file renames with .import/.uid, determinism for balance sims. Use whenever working in a repo with project.godot or editing .gd/.tscn/.tres files. A repo's own AGENTS.md/CLAUDE.md wins where it differs.
---

# Godot conventions

Small game projects: favor simple, understandable solutions over framework-like
architecture; code should be easy to change as gameplay ideas change.

## GDScript

- Typed GDScript. Explicitly type variables when inference would give `Variant`.
- Treat GDScript warnings as errors (set `debug/gdscript/warnings/*` in
  project.godot — otherwise the rule isn't enforced; headless runs don't print
  warnings).
- Keep functions focused; prefer early returns.
- No magic strings for concepts represented by enums, constants, Resources, or
  existing types (ids get named constants).

## Architecture

- Prefer scene/node composition over deep inheritance. Express static structure
  in scenes, not by constructing equivalent node trees in code.
- Add Nodes, Timers, components, and other design-time dependencies in the
  editor. Use `add_child()` / programmatic creation only for genuinely dynamic
  things: spawned enemies, projectiles, loot, transient effects, procedural
  content.
- Scripts extend the node type matching their role and operate on scene-provided
  children rather than creating them.
- Prefer `@export` node references or `%UniqueName` over hard-coded tree paths;
  keep references in `@onready` vars instead of searching the tree during play.
- Use custom Resources (`.tres`) for reusable configuration and data instead of
  string-keyed Dictionaries.
- Signals when a child reports an event without knowing the consumer; direct
  method calls when two objects intentionally have a close relationship.
- Avoid unnecessary Autoloads.
- Keep gameplay logic separate from presentation. A node-free RefCounted model
  driven by a fixed `step(dt)` is worth it when you want deterministic headless
  simulation (balance tests) — document that rationale in the model.
- Components: small scene-based nodes (HealthComponent, HurtArea, …) added in the
  editor, only where the behavior is reusable or independently meaningful. Don't
  extract a component just to shorten a script.

## Art and UI

- Prefer PNG art (editable in Aseprite) for fixed visuals — frames, panels,
  icons, buttons (9-slice `StyleBoxTexture`/`NinePatchRect`) — over `_draw()` or
  `StyleBoxFlat`. Generated art via a tool script that writes PNGs is fine.
- Pixel art: nearest filtering, integer scales; pack art at 32× needs
  downscaled copies (and 9-slice margins scale with it).
- Keep `assets/generated/` organized by kind (units/<kind>/, projectiles/,
  tower/, ui/, fx/ for overlays only, env/, skills/); ids = file names = icon
  names = PascalCase node names. Enforce the naming rule with a test.

## Headless tooling and tests

- Wrap the Godot binary in a script (e.g. `tools/godot.sh`) that serializes runs
  with a project-local lock (stale-PID reclaim + timeout) so parallel agents don't
  race on `.godot/`, and allows a windowed opt-out for screenshots.
- New `class_name` scripts and new PNGs need `--import` before tests see them.
- McpTestSuite/godot_ai test runners call tests synchronously: never `await` in a
  test. Step tweens with `tween.custom_step(duration + 0.01)`; emit
  `timer.timeout` directly; use an injectable clock instead of
  `Time.get_ticks_msec()` for rate limits.
- `-s` SceneTree scripts: root isn't ready in `_init`/`_initialize` — defer the
  work to the first `process_frame`; `-s` doesn't load the main scene, add it
  yourself. Drive runtime smoke tests by real frames with `--fixed-fps 60`.
- Gate set: `--import` (no SCRIPT ERROR / Parse Error / Failed to load), unit
  tests, `--quit-after N` (no ERROR lines), runtime smoke, gamepad-only smoke.
- Screenshot visual changes with the windowed binary
  (`get_viewport().get_texture().get_image().save_png()` after
  `await RenderingServer.frame_post_draw`) and actually look at them.

## Determinism and balance

- Seeded `RandomNumberGenerator`; give each new source of randomness (crits,
  view jitter) its own RNG so existing streams — and balance baselines — don't
  shift.
- Balance sims: run policies over 30+ seeds, not 3; diff deterministic log lines
  before/after changes; guard "not dominant" with a smooth score (e.g. HP margin),
  not just loss counts, and confirm the guard fails at the bad tuning.

## Input and focus (controller-friendly)

- Default `ui_accept` (4.7) has no joypad A — add it explicitly.
- A focused Button presses on release and does not consume the `ui_accept`
  press event, so it still reaches `_unhandled_input`.
- When the same button both acts in-game (e.g. spawn) and confirms menus, delay
  menu focus ~0.4 s after a screen appears so mashing can't buy/skip; give
  "start/continue" a dedicated binding that isn't `ui_accept`.
- Mouse hover and controller focus: one "selected" concept (focus), latest input
  wins.

## Engine pitfalls

- `Line2D` with `texture_mode = TILE` needs `texture_repeat = ENABLED`.
- TextureRect children of buttons default to `MOUSE_FILTER_PASS`; set IGNORE.
- A Control's `scale` is overridden inside Containers — tween scale only on
  direct children of non-container parents; set `pivot_offset` after sizing.
- Tweens: create with the node's `create_tween()` (dies with the node); kill and
  reset visuals before death/free animations; over-bright `modulate`
  (e.g. 1.8) for hit flashes — white is the identity.
- Building scenes from a tool script: set `owner` on every node before
  `PackedScene.pack`; save a TileSet with ResourceSaver and re-`load()` it before
  assigning; free the built tree before `quit()` to avoid "resources still in
  use" errors.
- Scripts that type a Resource field as their own class can leak at exit; use
  `Array[Resource]` and cast in loops.

## File moves and renames

- Use `git mv` plus text edits — not the editor or MCP filesystem tools (the
  editor may rewrite references with uids and churn files).
- Move each `.import` and `.gd.uid` with its file; fix `source_file`/`dest_files`
  or delete the `.import` and re-run `--import`.
- Update tool output paths (art generators) so a rerun writes the new locations;
  grep for every old name/path afterwards.
- Rename ids before a save system exists — it's free now and costly later.
