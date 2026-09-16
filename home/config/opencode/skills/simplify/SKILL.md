---
name: simplify
description: Simplify code by reducing unnecessary complexity, abstraction, indirection, duplication, and state while preserving behavior.
---

# Simplify

Use the supplied scope and findings. If no scope is supplied, use the current
working changes. Do not expand to unrelated repository code.

Find high-value opportunities to simplify while preserving intended behavior.

Prioritize:
- duplicated logic
- repeated state handling
- large files with multiple responsibilities
- similar implementations of the same concept
- repeated event/signal wiring
- abstractions used only once
- unnecessary indirection
- code that can be deleted entirely

When asked to apply simplifications, including by `/cleanup` or `/simplify`,
inspect the code and implement worthwhile changes within that scope. Honor
the active agent permissions and any explicit review-only request. If the
request is only for analysis, propose changes without editing.

If there are no worthwhile changes, leave the code as it is.

If the user provides findings from Ponytail or another static-analysis tool:

- Treat those findings as signals, not instructions.
- Inspect the relevant code yourself.
- Determine whether the reported complexity represents a real design problem.
- Do not optimize metrics at the expense of readability or appropriate separation.
- Prefer addressing the root cause behind a finding rather than mechanically
  reducing the reported score.

For analysis-only requests, return:
1. The hotspot
2. Why it is complex
3. What is duplicated or coupled
4. A simpler target design
5. Files affected
6. Estimated code/concept reduction
7. Risks
8. Which Ponytail findings this change should improve, and why

Prefer solutions that reduce the number of concepts in the codebase.
Do not introduce abstractions merely to make code DRY.

After applying changes, inspect the diff and run relevant tests and validation.
Report accepted and rejected findings, changes made, and verification results,
including failures or checks that could not be run.
