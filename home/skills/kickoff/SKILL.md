---
name: kickoff
description: Turn a raw product idea into PRD, architecture, stack decision and a milestone plan before any code is written. Use when starting a new project.
argument-hint: "<idea in 1-3 sentences>"
disable-model-invocation: true
---

Idea: $ARGUMENTS

Goal of this command: decision documents, not code. Keep every document short and concrete.

1. **Interrogate.** Ask me at most 7 sharp questions (use AskUserQuestion if available): target user and their current workaround, how it makes money and at what price, the 3 must-have v1 features, platforms (web / Telegram bot / Mini App / mobile), integrations, deadline, anything already decided. Wait for answers.
2. **Research in parallel** (delegate to `researcher` subagents, one per topic, only the topics that matter):
   - 3-5 competitors/alternatives: positioning, pricing, weak spots users complain about.
   - Key APIs/libraries: current versions, limits, pricing, required keys.
   - Payments/legal constraints for a seller in Uzbekistan if money is involved.
3. **PRD.** Write `docs/PRD.md`: problem, user, value proposition (1 sentence), v1 scope (Must / Should / Won't), non-goals, success metric for the first 30 days, pricing hypothesis.
4. **Architecture.** Delegate to `architect`: `docs/ARCHITECTURE.md` using the global default stack unless something forces otherwise.
5. **Plan.** Write `docs/PLAN.md`: milestones M0 (skeleton deployed) ... Mn; each milestone fits in one working day, has checkbox tasks and a runnable acceptance check (command, URL or bot message).
6. **Project memory.** Create `CLAUDE.md` from `~/.claude/templates/project/CLAUDE.md`, filled in for this project (keep it under 120 lines). Copy `~/.claude/templates/project/.claude/` into the repo if it is not there.
7. **Stop.** Show a 10-line summary, the riskiest assumption, and the exact first command to run for M0. Do not scaffold until I say go.
