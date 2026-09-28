---
description: File findings as beads, then fix them in parallel via worktrees
argument-hint: "[which findings / bead ids]"
---
File ${@:-all the findings above, including ones worth a follow-up,} as beads (with priority, description, and acceptance criteria), then show me the ids.

Then fix them in parallel using git worktrees, one worktree/branch per bead. Fall back to sequential only for beads that touch the same files or depend on each other — say which and why.

For each bead: implement, run verification (parse errors, warnings, tests), and make one commit per fix referencing the bead id. Then merge back into the current branch one at a time, re-running tests after each merge, and close the bead.

Clean up merged worktrees and branches when done. Do not push. Report per-bead status, any conflicts, and anything that couldn't be verified.
