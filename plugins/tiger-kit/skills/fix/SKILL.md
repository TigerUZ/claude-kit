---
name: fix
description: Disciplined bug fixing - reproduce, write a failing test, find the root cause, apply the minimal fix, prove it. Use for any bug, error message, failing test or issue number.
argument-hint: "<error text | symptom | issue number>"
disable-model-invocation: true
---

Bug: $ARGUMENTS

Repo state:
!`git status --short 2>/dev/null | head -15 || true`

Rules: no code changes before the bug is reproduced. No "try this" guessing loops.

1. **Understand.** If an issue number, `gh issue view`. Extract: expected vs actual, where it happens, since when (check `git log` of the suspected area).
2. **Reproduce.** Find the smallest reliable reproduction: a failing unit/integration test (preferred), a script, or exact steps. Show it failing.
3. **Hypothesise.** List 2-4 hypotheses ranked by likelihood, each with the evidence for it and the cheapest check that would falsify it.
4. **Investigate.** Run the checks (logs, targeted prints, debugger, `git bisect` if it is a regression). Delegate long log reading to a subagent. Remove temporary instrumentation afterwards.
5. **Root cause.** State it in one sentence with file:line. If the cause is upstream (library, API), say so and link the evidence.
6. **Fix.** Minimal change at the root cause, not at the symptom. Check for the same bug pattern elsewhere (`rg`) and list other occurrences.
7. **Prove.** The reproduction now passes; the related suite passes; typecheck/lint pass.
8. **Report.** Root cause, fix, test added, other occurrences, and whether a /lesson is worth recording.

If two investigation rounds fail, stop and present findings and the remaining hypotheses instead of guessing.
