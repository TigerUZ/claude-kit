---
name: blueprint
description: Plan a feature or issue before coding - map affected code, choose an approach, write a file-by-file plan with tests and risks. Use for changes touching 3+ files.
argument-hint: "<feature description | GitHub issue number>"
disable-model-invocation: true
---

Task: $ARGUMENTS

1. If the task is a number, load it with `gh issue view <n> --comments`.
2. Map the code: use an Explore subagent to find the entry points, data model, similar existing features and tests related to this task. Bring back file paths and a short description, not file dumps.
3. If anything about scope or behaviour is ambiguous, ask me up to 3 questions now.
4. Write `docs/plans/<yyyy-mm-dd>-<slug>.md`:
   - Goal and acceptance criteria (testable bullets).
   - Current behaviour (with file:line references).
   - Approach, plus one rejected alternative and why.
   - Changes, file by file (create / modify), including migrations, env vars, types to regenerate.
   - Test plan: which unit / integration / e2e tests, and the manual check.
   - Risks, rollout (feature flag?), and what could break for existing users.
   - Task checklist: steps of at most ~30 minutes each, in implementation order, each ending in a runnable check.
5. Stop and show me the plan summary. After I approve, implement task by task, ticking checkboxes in the plan file as you go and committing at green checkpoints.
