#!/usr/bin/env bash
# Installs the kit into ~/.claude (backing up anything it replaces).
#   ./install.sh            install global config + agents, skills, hooks, templates (no plugin)
#   ./install.sh --core     only CLAUDE.md + permissions; use together with the tiger-kit plugin
#   ./install.sh --project  full install, then copy the project template into the current directory
set -euo pipefail
KIT="$(cd "$(dirname "$0")" && pwd)"
PLUGIN="$KIT/plugins/tiger-kit"
MODE="${1:-}"
DEST="$HOME/.claude"
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST/backup-$TS"

command -v jq >/dev/null || { echo "jq is required by the hooks: brew install jq / apt install jq / winget install jqlang.jq"; exit 1; }
mkdir -p "$DEST"/{agents,skills,hooks,templates}

backup() { [ -e "$1" ] && { mkdir -p "$BACKUP"; cp -R "$1" "$BACKUP/"; echo "  backed up $(basename "$1")"; } || true; }

echo "Installing into $DEST"
backup "$DEST/CLAUDE.md"
backup "$DEST/settings.json"

cp "$KIT/home/CLAUDE.md" "$DEST/CLAUDE.md"

# --core: hooks come from the plugin, so drop the kit's hooks block
KIT_SETTINGS="$KIT/home/settings.json"
if [ "$MODE" = "--core" ]; then
  KIT_SETTINGS="$(mktemp)"
  jq 'del(.hooks)' "$KIT/home/settings.json" > "$KIT_SETTINGS"
fi

if [ -f "$DEST/settings.json" ]; then
  # merge: kit keys win for hooks; permission lists are unioned
  jq -s '
    .[0] as $old | .[1] as $kit |
    ($old * $kit)
    | .permissions.allow = ((($old.permissions.allow // []) + ($kit.permissions.allow // [])) | unique)
    | .permissions.ask   = ((($old.permissions.ask   // []) + ($kit.permissions.ask   // [])) | unique)
    | .permissions.deny  = ((($old.permissions.deny  // []) + ($kit.permissions.deny  // [])) | unique)
  ' "$DEST/settings.json" "$KIT_SETTINGS" > "$DEST/settings.json.tmp"
  mv "$DEST/settings.json.tmp" "$DEST/settings.json"
  echo "  merged settings.json (old copy in $BACKUP)"
else
  cp "$KIT_SETTINGS" "$DEST/settings.json"
fi

if [ "$MODE" = "--core" ]; then
  echo
  echo "Done (core). Now in claude: /plugin marketplace add TigerUZ/claude-kit, then /plugin install tiger-kit@tiger"
  [ -d "$BACKUP" ] && echo "Backup: $BACKUP"
  exit 0
fi

for d in agents skills hooks; do
  for item in "$PLUGIN/$d"/*; do
    name="$(basename "$item")"
    [ "$name" = "hooks.json" ] && continue   # plugin-only hook config
    [ -e "$DEST/$d/$name" ] && { mkdir -p "$BACKUP/$d"; cp -R "$DEST/$d/$name" "$BACKUP/$d/"; rm -rf "$DEST/$d/$name"; }
    cp -R "$item" "$DEST/$d/$name"
  done
done
chmod +x "$DEST"/hooks/*.sh

rm -rf "$DEST/templates/project"
cp -R "$PLUGIN/templates/project" "$DEST/templates/project"
chmod +x "$DEST"/templates/project/.claude/hooks/*.sh

if [ "$MODE" = "--project" ]; then
  [ -f CLAUDE.md ] && echo "  CLAUDE.md exists here, not overwriting" || cp "$PLUGIN/templates/project/CLAUDE.md" ./CLAUDE.md
  mkdir -p .claude/hooks docs/plans docs/research
  cp -n "$PLUGIN/templates/project/.claude/settings.json" .claude/ 2>/dev/null || true
  cp -n "$PLUGIN/templates/project/.claude/hooks/"*.sh .claude/hooks/ 2>/dev/null || true
  chmod +x .claude/hooks/*.sh
  [ -f .mcp.json ] || cp "$PLUGIN/templates/project/.mcp.json" .mcp.json
  grep -qxF '.claude/settings.local.json' .gitignore 2>/dev/null || echo '.claude/settings.local.json' >> .gitignore
  echo "  project template copied into $(pwd)"
fi

echo
echo "Done. Agents: $(ls "$DEST/agents" | wc -l | tr -d ' ')  Skills: $(ls "$DEST/skills" | wc -l | tr -d ' ')  Hooks: $(ls "$DEST/hooks" | wc -l | tr -d ' ')"
[ -d "$BACKUP" ] && echo "Backup: $BACKUP"
echo "Next: ./setup-plugins.sh, then run claude and check /hooks, /context and \"what skills are available?\""
