---
name: ship
description: Verify, commit with a Conventional Commit message, push the branch and open a GitHub PR with a proper description.
argument-hint: "[extra context for the PR]"
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git push -u origin *) Bash(git switch -c *) Bash(gh pr create *) Bash(pnpm typecheck*) Bash(pnpm lint*) Bash(pnpm test*)
---

Context: $ARGUMENTS

Current state:
!`git branch --show-current 2>/dev/null; git status --short 2>/dev/null | head -30 || true`

1. **Branch.** If on main/master, create `feat/<slug>` or `fix/<slug>` from the change content with `git switch -c`.
2. **Verify.** Run the project's typecheck, lint and tests (read package.json scripts; skip what does not exist). If anything fails, stop and report - do not ship red.
3. **Hygiene.** Check the diff for: debug logs, commented-out code, TODOs added without an issue, secrets, large binaries, unrelated changes. Fix or ask.
4. **Commit.** Group into logical commits if the diff mixes concerns. Conventional Commit subject (<= 72 chars, imperative), body explains why. Never `--no-verify`.
5. **Push.** `git push -u origin <branch>`. Never force.
6. **PR.** `gh pr create` with title = main commit subject, body:
   - Summary (why + what, 2-4 bullets)
   - Changes (grouped by area)
   - How it was tested (commands + results; screenshots needed? say where)
   - Risks / rollout / migration notes
   - Closes #<issue> if known
7. Print the PR URL and the CI status command (`gh pr checks --watch`).
