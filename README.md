# claude-kit: Claude Code setup for web / SaaS / Telegram / mobile / AI / video

## Install (macOS / Linux / WSL; needs jq)
```bash
unzip claude-kit.zip && cd claude-kit
./install.sh                 # ~/.claude: CLAUDE.md, settings.json (merged), 14 agents, 14 skills, 5 hooks, templates
./setup-plugins.sh           # plugins, external skills, MCP (read it first; comment out what you don't need)
cd ~/code/my-project && ~/path/to/claude-kit/install.sh --project   # per-project template
```
Existing files are backed up to `~/.claude/backup-<timestamp>/`. An existing settings.json is merged, not replaced.

## Layout
```
home/                       -> ~/.claude/
  CLAUDE.md                 global rules (short on purpose: loaded every session)
  settings.json             permissions (allow/ask/deny) + hooks
  hooks/
    guard-bash.sh           PreToolUse(Bash): blocks rm -rf /, force push, printing .env; asks on reset --hard, DROP, prod deploys
    protect-files.sh        PreToolUse(Edit|Write): no edits to .env*, lockfiles, .git; asks before editing applied migrations
    format.sh               PostToolUse(Edit|Write): runs project's biome/prettier/ruff/gofmt on the touched file
    session-context.sh      SessionStart: branch, dirty files, last commits, docs/HANDOFF.md
    notify.sh               Notification: desktop notification when Claude waits for you
  agents/                   architect, researcher, code-reviewer, security-auditor, qa-engineer,
                            frontend-, backend-, db-architect, telegram-, mobile-, ai-, devops-, video-engineer, ui-designer
  skills/                   /kickoff /blueprint /fix /audit /ship /handoff /lesson /research
                            /tg-bot /mini-app /saas /landing /deploy  + ffmpeg-video (auto-loaded knowledge skill)
project-template/           -> ~/.claude/templates/project (and copied into a repo by --project)
  CLAUDE.md                 project memory template
  .claude/settings.json     project permissions + opt-in Stop hook (typecheck gate)
  .claude/hooks/typecheck-gate.sh
  .mcp.json                 Supabase MCP, read-only, scoped to one project via $SUPABASE_PROJECT_REF
```

Skills are the current format for slash commands (`.claude/commands/*.md` still works, but skills support
frontmatter like `disable-model-invocation`, `context: fork`, `allowed-tools` and supporting files).
To make a command project-only, move its folder to `<repo>/.claude/skills/`.

## Verify
In `claude`: `/hooks` (5 hooks listed), type `/` (kit commands visible), `/context` (check token cost of tools/skills/agents),
then try: `rm -rf .` request -> blocked; edit `.env` -> denied.
