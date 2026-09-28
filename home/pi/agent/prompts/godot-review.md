---
description: Parallel godot-master review (correctness, tests, complexity) → ranked top N
argument-hint: "[count] [focus]"
---
Run parallel godot-master reviewers: one for correctness, one for tests, and one for unnecessary complexity. ${@:2}

Gather their results, dedupe, rank by impact vs. effort, and give me a list of the top ${1:-5} things to fix and/or clean up. For each: file/location, problem, suggested fix, rough size. Separately list findings worth a follow-up that didn't make the cut.

Do not change code or file beads yet — wait for me.
