---
description: Audit recent changes for complexity and quality issues, then simplify actionable findings
---

# Cleanup

Review the current implementation and simplify it where doing so provides
clear value.

The goal is not to produce zero audit findings.

The goal is to leave the implementation simpler and easier to understand
without changing its intended behavior. A finding may be rejected when
addressing it would add complexity, abstraction, indirection, or scope
without sufficient benefit.

## 1. Determine scope

Identify the code changed for the current task.

Prefer reviewing the current working-tree diff. If there is no working-tree
diff, determine the relevant changes from the current branch.

Do not expand the scope to unrelated existing code.

## 2. Run audits

Run the following as independent subagents. They are reviewers only and must
not modify files.

### Ponytail audit

Run `ponytail-audit` against the scoped changes.

Ask it to return concrete, actionable findings. Preserve file and line
references where available.

### Complexity review

Run `complexity-review` against the same scoped changes.

Ask it to identify unnecessary complexity, excessive abstraction,
duplication, confusing control flow, unnecessary state, and opportunities
to make the implementation smaller or more direct.

Preserve file and line references where available.

Run these reviews in parallel if possible.

## 3. Consolidate findings

Collect the output from both reviewers.

Create one consolidated set of findings:

- Deduplicate overlapping findings.
- Combine findings that describe the same underlying problem.
- Preserve useful context from each reviewer.
- Discard speculative or low-value suggestions.
- Discard findings unrelated to the scoped changes.
- Do not treat reviewer suggestions as requirements.
- Prefer changes that reduce code, concepts, state, indirection, or
  cognitive load.
- Do not introduce abstractions merely to satisfy a finding.

If the reviewers disagree, prefer the simpler implementation unless there
is a correctness, maintainability, or project-specific reason not to.

## 4. Simplify

If there are actionable findings, invoke `simplify` with:

1. The original task/change context.
2. The scoped diff.
3. The consolidated findings.
4. Any relevant reasoning from the reviewers.

Ask `simplify` to address the findings as a coherent cleanup pass rather
than mechanically applying every recommendation.

If there are no worthwhile findings, make no changes.

## 5. Verify

After simplification:

- Inspect the resulting diff.
- Ensure behavior has not intentionally changed.
- Ensure cleanup did not expand beyond the original scope.
- Run the relevant tests and validation for the changed code.

Report:

- findings from Ponytail
- findings from complexity-review
- findings accepted/rejected during consolidation
- changes made by simplify
- verification/test results
