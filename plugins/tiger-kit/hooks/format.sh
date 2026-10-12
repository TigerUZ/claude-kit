#!/usr/bin/env bash
# PostToolUse(Edit|Write): format the touched file with the project's own formatter, if it has one.
# Silent and always exit 0: formatting must never block or spam the session.
input=$(cat)
f=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')
[ -z "$f" ] || [ ! -f "$f" ] && exit 0
root="${CLAUDE_PROJECT_DIR:-$(pwd)}"

case "$f" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.md|*.mdx|*.html|*.yml|*.yaml)
    if [ -x "$root/node_modules/.bin/biome" ] && [ -f "$root/biome.json" ]; then
      "$root/node_modules/.bin/biome" format --write "$f" >/dev/null 2>&1
    elif [ -x "$root/node_modules/.bin/prettier" ]; then
      "$root/node_modules/.bin/prettier" --write --log-level silent "$f" >/dev/null 2>&1
    fi ;;
  *.py)   command -v ruff  >/dev/null && ruff format -q "$f" >/dev/null 2>&1 ;;
  *.go)   command -v gofmt >/dev/null && gofmt -w "$f" >/dev/null 2>&1 ;;
  *.dart) command -v dart  >/dev/null && dart format "$f" >/dev/null 2>&1 ;;
  *.sh)   : ;;
esac
exit 0
