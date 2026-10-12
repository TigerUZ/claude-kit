#!/usr/bin/env bash
# Plugins, external skills and MCP servers. Review before running; comment out what you do not need.
# Names verified against public docs in Oct 2026. If an install fails, open `/plugin` -> Discover and search by name.
set -u
ok()   { echo "  ✓ $*"; }
try()  { echo "→ $*"; "$@" && ok "done" || echo "  ✗ failed (check the name in /plugin -> Discover)"; }

echo "== 1. Official marketplace plugins (claude-plugins-official is preinstalled) =="
# MUST HAVE
try claude plugin install context7@claude-plugins-official          # live, version-specific library docs (MCP)
try claude plugin install playwright@claude-plugins-official        # browser automation / e2e / screenshots (MCP)
try claude plugin install frontend-design@claude-plugins-official   # non-generic UI design skill (Anthropic)
try claude plugin install typescript-lsp@claude-plugins-official    # go-to-definition / diagnostics via LSP (needs: npm i -g typescript-language-server typescript)
try claude plugin install security-guidance@claude-plugins-official # warns on insecure patterns while editing (hooks)
try claude plugin install skill-creator@claude-plugins-official     # create + eval your own skills
# STACK-SPECIFIC (install when you start that kind of project)
# try claude plugin install supabase@claude-plugins-official        # Supabase MCP (OAuth). Prefer project-scoped read_only .mcp.json instead
# try claude plugin install vercel@claude-plugins-official          # deployments, logs, env
# try claude plugin install expo@claude-plugins-official            # Expo skills + Expo MCP (week 3, mobile)
# try claude plugin install pyright-lsp@claude-plugins-official     # if you write Python (video/AI scripts)
# try claude plugin install figma@claude-plugins-official           # only with a Figma Dev/Full seat
# try claude plugin install sentry@claude-plugins-official          # when something is in production

echo "== 2. Agent Skills from the open ecosystem (skills.sh CLI) =="
# -g = global (~/.claude/skills), -a = target agent, -y = no prompts
try npx -y skills add vercel-labs/agent-skills --skill react-best-practices -g -a claude-code -y
try npx -y skills add vercel-labs/agent-skills --skill web-design-guidelines -g -a claude-code -y
try npx -y skills add supabase/agent-skills --skill supabase-postgres-best-practices -g -a claude-code -y
# Week 3 (mobile without the Expo plugin):
# try npx -y skills add vercel-labs/agent-skills --skill react-native-guidelines -g -a claude-code -y
# Week 1 experiment, optional (heavy methodology; overlaps with /blueprint and /fix from this kit):
# claude plugin marketplace add obra/superpowers-marketplace && claude plugin install superpowers@superpowers-marketplace

echo "== 3. MCP servers not covered by plugins =="
# GitHub: use the gh CLI (gh auth login). It is cheaper in context than the GitHub MCP.
# Sentry (remote, OAuth) - add when you have production traffic:
# try claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp
# Notion (remote, OAuth) - only if your specs/tasks live in Notion:
# try claude mcp add --transport http --scope user notion https://mcp.notion.com/mcp

echo "== 4. CLIs Claude will drive (install yourself) =="
for c in gh supabase vercel docker ffmpeg jq rg; do
  command -v "$c" >/dev/null && ok "$c" || echo "  ✗ $c missing"
done
echo
echo "Then inside claude: /mcp (authenticate servers), /plugin (review), /context (see what all this costs in tokens)."
