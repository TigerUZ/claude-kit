---
name: handoff
description: Save the current session state to docs/HANDOFF.md so the next session (after /clear, a new day, or another machine) resumes instantly. Use before /clear or when context is getting full.
disable-model-invocation: true
---

Write `docs/HANDOFF.md` (overwrite it; max ~60 lines; terse; file:line references instead of code):

```
# Handoff - <date time>
## Goal
<what we are building in this stretch of work, 1-2 lines; link plan file if any>
## Done
- <item> (commit <sha> | uncommitted)
## In progress
- <exactly where I stopped: file:line, what is half-done, what is broken right now>
## Next steps
1. <concrete next action, small enough to start immediately>
## Decisions & why
- <decision> - <reason> (so we do not relitigate it)
## Gotchas found
- <surprising behaviour, workaround>
## Verify
- <commands that show the current state works / what is failing>
```

Then:
- If there are gotchas worth keeping forever, propose them as one-line additions to the project CLAUDE.md (do not add without my OK).
- If uncommitted work is in a good state, suggest a WIP commit.
- Tell me it is safe to run `/clear`. The SessionStart hook will load this file automatically next time.
