---
name: lesson
description: Record a lesson learned (a correction I gave, a gotcha, a convention) as a one-line rule in the right memory file so the mistake does not repeat.
argument-hint: "[the lesson; omit to infer from my last correction]"
disable-model-invocation: true
---

Lesson: $ARGUMENTS

(If empty, infer the lesson from the most recent correction or surprise in this conversation.)

1. Phrase it as one imperative line with the reason, e.g. `Use supabase gen types --local after every migration - CI typecheck depends on it.`
2. Choose the narrowest correct home:
   - Specific to this repo -> project `CLAUDE.md` under `## Gotchas`.
   - Specific to one directory/area -> that area's nested `CLAUDE.md`, or a `.claude/rules/*.md` file with `paths:` frontmatter.
   - A multi-step procedure -> a skill (propose creating `.claude/skills/<name>/SKILL.md` instead).
   - True for all my projects -> `~/.claude/CLAUDE.md`.
   - Must never be violated -> also suggest a hook or permission rule, since CLAUDE.md is guidance, not enforcement.
3. Check for duplicates or contradictions in the target file; update instead of appending if one exists.
4. Show me the diff, then apply it.
