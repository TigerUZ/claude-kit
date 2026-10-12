#!/usr/bin/env bash
# PreToolUse(Edit|Write|NotebookEdit): keep Claude away from secrets, lockfiles, .git and applied migrations.
set -u
input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.notebook_path // ""')
[ -z "$path" ] && exit 0
path="${path//\\//}"            # normalise Windows separators
base="${path##*/}"

out() { jq -n --arg d "$1" --arg r "protect-files: $2" \
  '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'; exit 0; }

case "$base" in
  .env.example|.env.sample|.env.template) exit 0 ;;
  .env|.env.*) out deny "$base holds secrets. Edit .env.example and tell the user which variables to set." ;;
  pnpm-lock.yaml|package-lock.json|yarn.lock|bun.lockb|bun.lock|poetry.lock|uv.lock|Podfile.lock)
    out deny "$base is generated. Change dependencies with the package manager instead." ;;
esac

case "$path" in
  */.git/*) out deny "never write inside .git/" ;;
  */supabase/migrations/*.sql|*/migrations/*.sql)
    [ -f "$path" ] && out ask "editing an existing migration. If it is already applied anywhere, create a new migration instead." ;;
esac
exit 0
