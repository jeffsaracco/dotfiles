---
description: Review current changes for unnecessary complexity
agent: plan
---

Compare the current branch against main from a maintainability perspective.

Look specifically for:
- new duplication
- new abstractions
- functions that became substantially larger
- classes taking on additional responsibilities
- repeated event/signal handling
- repeated state
- concepts implemented differently in multiple places

Ignore complexity that is inherent to the feature.

Determine whether this change introduces avoidable complexity.

Propose at most 3 simplifications.

Do not make changes.
