# Engineering preferences

## General principles

- Prefer simple solutions over clever ones.
- Prefer reducing concepts, code paths, and state.
- Avoid speculative abstractions for features that do not exist yet.
- Do not introduce an abstraction solely because two small pieces of code
  happen to look similar.
- DRY code when duplicated code represents the same underlying concept.
- Prefer deleting or consolidating code over adding wrappers or indirection.
- Keep changes scoped to the requested task.
- Do not refactor unrelated code without explaining why it is necessary.
- Prefer descriptive names over comments explaining unclear names.
- Avoid magic strings for concepts represented by enums, constants, or types.
- Follow the style already established in nearby code unless there is a good
  reason to change it.

## State and data ownership

- Every important piece of mutable state should have a clear owner.
- Avoid maintaining duplicate representations of the same state; other
  components query or react to the owner instead of keeping synchronized copies.
- When the same fact must live in two places (e.g. code and a scene/config),
  pick one source of truth and derive the other, or guard the copy with a test.
- When adding state, decide who owns it before implementing behavior around it.

## Working with existing code

Before changing a system:

- Read the relevant existing implementation.
- Identify its callers and dependencies.
- Look for other implementations of the same concept elsewhere in the repo.
- Preserve intentional existing behavior unless the task explicitly changes it.

Do not assume a system is unused based only on local references; scenes,
config, data files, reflection, and signals/events may reference code
indirectly.

## Refactoring

Optimize for reduced complexity rather than architectural sophistication.
Before a substantial refactor, identify what complexity or duplication is
removed, which concepts consolidate, which code can be deleted, and what
behavior must stay unchanged.

A successful refactor usually yields less code, fewer concepts, fewer
responsibilities per class, less duplicated state or behavior, simpler
dependencies, or clearer ownership. Be suspicious of refactors that grow the
code or add several new types without removing equivalent complexity.

- Capture a behavior baseline (test output, deterministic logs, snapshots)
  before changing anything, and diff against it after.
- Keep behavior fixes out of refactor commits so "no behavior change" stays
  provable.
- Renames: change every reference in one pass, then grep for the old names.

## Verification

After making changes:

- Check for parse/compile errors and new warnings.
- Run the available tests and checks.
- Verify affected config, scene, and resource files still reference valid paths.
- For visual or UI changes, look at real screenshots — layout, overlap, and
  readability problems rarely show up in unit tests.
- A test that can't fail proves nothing: when adding a guard test, confirm it
  fails against the bug or bad tuning it is meant to catch.
- Call out anything that could not be verified automatically.

## Parallel agent work

- Give each parallel workstream its own git worktree and an explicit list of
  files it owns; merge in a planned order and re-run all checks after merging.
- Don't trust results gathered while another agent was mid-edit on shared
  files; re-verify on the finished code.
