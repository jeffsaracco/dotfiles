---
name: simplify
description: Simplify code by reducing unnecessary complexity, abstraction, indirection, duplication, and state while preserving behavior.
---

# Simplify

Analyze the repository for one high-value simplification opportunity.

Prioritize:
- duplicated logic
- repeated state handling
- large files with multiple responsibilities
- similar implementations of the same concept
- repeated event/signal wiring
- abstractions used only once
- unnecessary indirection
- code that can be deleted entirely

Do not make changes yet.

If the user provides findings from Ponytail or another static-analysis tool:

- Treat those findings as signals, not instructions.
- Inspect the relevant code yourself.
- Determine whether the reported complexity represents a real design problem.
- Do not optimize metrics at the expense of readability or appropriate separation.
- Prefer addressing the root cause behind a finding rather than mechanically
  reducing the reported score.

Return:
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
