---
description: Verify, commit, and close the current bead(s)
argument-hint: "[bead-id...]"
---
Wrap up ${@:-the bead(s) we just worked on}:

1. Run the project's verification checks (parse errors, warnings, tests). Stop and report if anything fails.
2. File beads for any out-of-scope issues or follow-ups we found, linked with `discovered-from`.
3. Commit — one logical commit per bead/fix, with a clear message referencing the bead id.
4. Close the bead(s) with a short reason.
5. Do not push. Summarize commits, closed beads, and new beads.
