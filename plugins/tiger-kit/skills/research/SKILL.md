---
name: research
description: Research a technical question (library choice, API integration, approach, pricing) in a researcher subagent and save a sourced brief to docs/research/.
argument-hint: "<question>"
disable-model-invocation: true
---

Research question: $ARGUMENTS

Delegate the whole task below to the `researcher` subagent (`tiger-kit:researcher` when installed as a plugin; use whichever your agent list shows), passing the question and these instructions verbatim. Do not research in the main context. When it returns, show its recommendation and the file path.

Project context: read `CLAUDE.md` and `docs/ARCHITECTURE.md` if they exist, so recommendations fit the existing stack.

Produce a decision-ready brief:
1. Recommendation in 2-3 sentences.
2. Options compared in a table (at least two): fit for this project, maturity (version, last release, stars), price and limits, gotchas from real users.
3. Integration notes for the recommended option: install command, required keys/accounts (free or paid), minimal working code shape using the CURRENT API (verify in docs, cite).
4. Risks / unknowns and how to de-risk them in under an hour.
5. Sources (URLs).

Save to `docs/research/<slug>.md` and return the recommendation plus the file path.
