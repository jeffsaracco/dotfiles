---
description: Improve code clarity and intent without changing architecture
agent: plan
---

Review the requested code for opportunities to make its intent easier to understand.

Prioritize:
- unclear variable, function, class, and signal names
- magic numbers and magic strings
- boolean parameters whose meaning is unclear at call sites
- ambiguous conditionals
- overly clever expressions
- implicit assumptions that should be made explicit
- weak or overly broad types
- misleading, stale, or redundant comments
- comments that explain "what" instead of making the code itself clearer
- inconsistent terminology for the same concept
- functions whose names do not accurately describe their behavior

Prefer:
- better names
- named constants or enums
- explicit types
- small local rewrites that expose intent
- clear intermediate variables when they improve readability
- deleting unnecessary comments after the code becomes self-explanatory

Avoid:
- architectural refactors
- introducing new components/classes solely for readability
- changing public behavior
- changing ownership of state
- broad DRY refactors
- speculative abstractions
- increasing indirection

Do not make changes yet.

Return:
1. The clearest problems you found
2. Why each one is difficult to understand
3. The smallest change that would improve it
4. Any places where a clarification would conflict with simplification
5. At most 5 recommended changes
