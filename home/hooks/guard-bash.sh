#!/usr/bin/env bash
# PreToolUse(Bash) guard.
#   deny -> exit 2 (stderr is shown to Claude, the call is blocked)
#   ask  -> JSON permissionDecision "ask" (you get a confirmation prompt even in auto/acceptEdits)
# Best-effort safety net. Hard rules also live in settings.json "permissions.deny".
set -u
input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
[ -z "$cmd" ] && exit 0

deny() { echo "BLOCKED by guard-bash: $1. If this is really needed, ask the user to run it manually." >&2; exit 2; }
ask()  { jq -n --arg r "guard-bash: $1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'; exit 0; }
has()  { printf '%s' "$cmd" | grep -Eiq -- "$1"; }

# --- hard deny ---------------------------------------------------------------
has '(^|[;&|[:space:]])(sudo[[:space:]]+)?rm[[:space:]]+-[[:alpha:]]*[rR][[:alpha:]]*[[:space:]]+(/|~|\$HOME|\.|\.\.|\*)([[:space:]]|/?$)' \
  && deny "recursive delete of /, ~, . or *"
has 'git[[:space:]]+push([^|;&]*)[[:space:]](--force|-f)([[:space:]]|$)' && ! has 'force-with-lease' \
  && deny "force push (use --force-with-lease on your own branch, and only when asked)"
has '(^|[;&|[:space:]])(cat|less|more|head|tail|bat)[[:space:]][^|;&]*\.env(\.[a-z]+)?([[:space:]]|$)' && ! has '\.env\.(example|sample|template)' \
  && deny "printing a .env file (secrets). Read .env.example instead"
has '(^|[;&|[:space:]])(printenv|env)[[:space:]]*($|[|;&])' \
  && deny "dumping the whole environment"
has 'mkfs|dd[[:space:]]+if=.*of=/dev/' && deny "disk-level write"

# --- ask first ---------------------------------------------------------------
has 'git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[[:alpha:]]*f|checkout[[:space:]]+--[[:space:]]+\.|restore[[:space:]]+\.)' \
  && ask "discards uncommitted work"
has '(drop[[:space:]]+(database|schema|table)|truncate[[:space:]]+(table[[:space:]]+)?[a-z_"])' \
  && ask "destructive SQL"
has 'supabase[[:space:]]+(db[[:space:]]+(push|reset)|link)' \
  && ask "touches a linked (possibly production) Supabase database"
has '(vercel[^|;&]*--prod|vercel[[:space:]]+promote|eas[[:space:]]+submit|eas[[:space:]]+update[^|;&]*production|fly[[:space:]]+deploy|railway[[:space:]]+up)' \
  && ask "production deploy/release"
has '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z)?sh' \
  && ask "pipes a remote script into a shell"
has 'npm[[:space:]]+publish|pnpm[[:space:]]+publish' && ask "publishes a package"

exit 0
