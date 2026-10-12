#!/usr/bin/env bash
# Stop hook (opt-in, per project): if Claude touched TypeScript this turn and typecheck fails,
# don't let it stop; feed the first errors back instead. Loop guard: max 3 blocks per session.
input=$(cat)
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
sid=$(printf '%s' "$input" | jq -r '.session_id // "x"')
[ "$active" = "true" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}" || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
changed=$( { git diff --name-only HEAD; git ls-files --others --exclude-standard; } 2>/dev/null | grep -E '\.(ts|tsx)$' )
[ -z "$changed" ] && exit 0

[ -f tsconfig.json ] || grep -q "\"typecheck\"" package.json 2>/dev/null || exit 0
counter="${TMPDIR:-/tmp}/claude-tsgate-$sid"
n=$(cat "$counter" 2>/dev/null || echo 0)
[ "$n" -ge 3 ] && exit 0

if grep -q '"typecheck"' package.json 2>/dev/null; then cmd="pnpm -s typecheck"; else cmd="npx -y tsc --noEmit -p ."; fi
out=$($cmd 2>&1); code=$?
[ $code -eq 0 ] && { rm -f "$counter"; exit 0; }

echo $((n+1)) > "$counter"
errs=$(printf '%s\n' "$out" | grep -E 'error TS' | head -25)
jq -n --arg r "Typecheck failed (\`$cmd\`). Fix these before finishing:
$errs" '{decision:"block", reason:$r}'
