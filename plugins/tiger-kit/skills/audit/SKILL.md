---
name: audit
description: Pre-merge quality gate on the current branch - parallel code review, security audit and test-gap analysis by specialist subagents, with findings verified and deduplicated.
argument-hint: "[base branch, default origin/main] [focus]"
disable-model-invocation: true
---

Arguments: $ARGUMENTS

Scope: changes on the current branch vs the base branch given in the arguments (default `origin/main`; if there is no remote, vs HEAD including uncommitted changes).

Changed files:
!`(git diff --stat --merge-base origin/main 2>/dev/null || git diff --stat HEAD 2>/dev/null) | tail -40 || true`

1. If the diff is empty, say so and stop. If it is huge (> ~1500 changed lines), propose splitting the review by area and ask.
2. Launch in parallel, each with the base ref and the list of changed files:
   - `code-reviewer` - correctness, contracts, data, consistency.
   - `security-auditor` - scoped to the diff and anything it touches in auth/payments/webhooks/user data.
   - `qa-engineer` - in REPORT-ONLY mode: list behaviours changed without tests and the tests that should exist; do not write files.
3. Consolidate: merge duplicates, re-read the code for every Critical/High finding to confirm it (drop what you cannot confirm), and sort by severity.
4. Output one table: `# | severity | area | path:line | issue | proposed fix | confidence`. Then: verdict (SHIP / FIX FIRST / RETHINK) and the 3 most important fixes.
5. Ask which findings to fix. Fix the chosen ones one commit each, then rerun typecheck and tests.

Subagent names: as a plugin these agents are `tiger-kit:<name>` (e.g. `tiger-kit:researcher`); with install.sh they are the bare `<name>`. Use whichever form your agent list shows.

For a quick single-dimension pass, the built-in `/code-review` and `/security-review` are cheaper; this command is the full gate before merging or deploying.
