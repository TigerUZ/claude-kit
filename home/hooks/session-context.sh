#!/usr/bin/env bash
# SessionStart: give Claude the current repo state + last handoff, so you never re-explain where you stopped.
# Plain stdout from a SessionStart hook is added to Claude's context.
cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

echo "Repo state at session start:"
echo "- Branch: $(git branch --show-current 2>/dev/null || echo detached)"
changes=$(git status --short 2>/dev/null | head -20)
if [ -n "$changes" ]; then echo "- Uncommitted changes:"; echo "$changes" | sed 's/^/    /'; else echo "- Working tree clean"; fi
echo "- Recent commits:"; git log --oneline -5 2>/dev/null | sed 's/^/    /'

if [ -f docs/HANDOFF.md ]; then
  echo
  echo "Last session handoff (docs/HANDOFF.md, first 60 lines):"
  head -60 docs/HANDOFF.md
fi
exit 0
