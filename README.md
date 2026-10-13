# claude-kit: набор настроек Claude Code для web / SaaS / Telegram / mobile / AI / video

Репозиторий служит маркетплейсом плагинов Claude Code (`tiger`). В нём один плагин, `tiger-kit`: 14 субагентов, 14 скиллов и 5 хуков.
Кроме плагина есть `install.sh`: глобальный `CLAUDE.md` и permissions плагином не доставить, их ставит он.

## Установка через маркетплейс (рекомендуется)

В Claude Code:
```
/plugin marketplace add TigerUZ/claude-kit
/plugin install tiger-kit@tiger
```
Или из шелла: `claude plugin marketplace add TigerUZ/claude-kit && claude plugin install tiger-kit@tiger`.

Потом поставь глобальные правила и permissions (хуки, агенты и скиллы этот режим не трогает, их даёт плагин). Нужен `jq`:
```bash
git clone https://github.com/TigerUZ/claude-kit ~/code/claude-kit
~/code/claude-kit/install.sh --core
```

### Что даёт плагин, а что только install.sh

| Компонент | Плагин `tiger-kit` | `install.sh --core` | `install.sh` (полный) |
|---|---|---|---|
| 14 субагентов | ✓ (`tiger-kit:<имя>`) | | ✓ (`<имя>`) |
| 14 скиллов | ✓ (`/tiger-kit:<имя>`) | | ✓ (`/<имя>`) |
| 5 хуков | ✓ | | ✓ |
| Шаблон проекта | ✓ (`${CLAUDE_PLUGIN_ROOT}/templates/project`) | | ✓ (`~/.claude/templates/project`) |
| `~/.claude/CLAUDE.md` | ✗ плагины не грузят CLAUDE.md | ✓ | ✓ |
| permissions allow/ask/deny | ✗ плагины не задают permissions | ✓ | ✓ |

### Имена в плагине
Все компоненты плагина получают неймспейс:
- скиллы: `/tiger-kit:kickoff`, `/tiger-kit:fix`, `/tiger-kit:ship`, `/tiger-kit:research` и т.д.;
- агенты: `tiger-kit:architect`, `@agent-tiger-kit:code-reviewer`.

Скиллы работают при обоих способах установки: в их тексте указаны обе формы имени агента (`tiger-kit:<имя>` и `<имя>`), и Claude берёт ту, что есть в списке агентов. Поэтому `/research` делегирует субагенту из тела скилла, а не через `context: fork` + `agent:` (там не резолвится имя агента плагина без префикса).

### Обновления
Версия в `plugin.json` не задана, поэтому новой версией считается каждый коммит в `main`.
- Вручную: `/plugin marketplace update tiger`, затем `/reload-plugins` или перезапуск сессии.
- Автоматически: включи auto-update для маркетплейса `tiger` в `/plugin`.

### Миграция со старой установки через install.sh
Плагин **нельзя** ставить поверх полной установки через `install.sh`: хуки сработают дважды, агенты и скиллы задублируются (причём личные `~/.claude/agents` перекрывают агентов плагина). Перед установкой плагина:
1. Удали из `~/.claude/agents/` и `~/.claude/skills/` файлы и папки кита, а из `~/.claude/hooks/` его 5 скриптов (`guard-bash.sh`, `protect-files.sh`, `format.sh`, `session-context.sh`, `notify.sh`).
2. Удали блок `"hooks"` из `~/.claude/settings.json`, где хуки указывают на `$HOME/.claude/hooks/...` (или запусти `install.sh --core`: он не добавит хуки, но и старые не удалит).
3. Поставь плагин, как описано выше.

## Альтернатива: только install.sh (без плагина)
```bash
./install.sh             # ~/.claude: CLAUDE.md, settings.json (merge), 14 агентов, 14 скиллов, 5 хуков, шаблон проекта
./install.sh --core      # только CLAUDE.md + permissions (пара к плагину)
cd ~/code/my-project && ~/code/claude-kit/install.sh --project   # полная установка + шаблон проекта в текущую папку
./setup-plugins.sh       # сторонние плагины, скиллы и MCP (сначала прочитай, лишнее закомментируй)
```
Перед перезаписью существующие файлы копируются в `~/.claude/backup-<timestamp>/`. Существующий `settings.json` не заменяется, а объединяется с китовым: списки permissions сливаются.

## Структура
```
.claude-plugin/marketplace.json      маркетплейс "tiger" → plugins/tiger-kit
plugins/tiger-kit/
  .claude-plugin/plugin.json         манифест плагина
  agents/                            architect, researcher, code-reviewer, security-auditor, qa-engineer,
                                     frontend-, backend-, db-architect, telegram-, mobile-, ai-, devops-, video-engineer, ui-designer
  skills/                            kickoff blueprint fix audit ship handoff lesson research
                                     tg-bot mini-app saas landing deploy + ffmpeg-video (подгружается автоматически)
  hooks/
    hooks.json                       подключение хуков в плагине (через ${CLAUDE_PLUGIN_ROOT})
    guard-bash.sh                    PreToolUse(Bash): блокирует rm -rf /, force push, вывод .env; спрашивает про reset --hard, DROP, прод-деплой
    protect-files.sh                 PreToolUse(Edit|Write): запрещает правки .env*, lock-файлов и .git; спрашивает перед правкой применённых миграций
    format.sh                        PostToolUse(Edit|Write): форматирует файл форматтером проекта (biome/prettier/ruff/gofmt)
    session-context.sh               SessionStart: ветка, незакоммиченные файлы, последние коммиты, docs/HANDOFF.md
    notify.sh                        Notification: системное уведомление, когда Claude ждёт ответа
  templates/project/                 шаблон проекта: CLAUDE.md, .claude/settings.json + typecheck-gate, .mcp.json (Supabase MCP read-only)
home/
  CLAUDE.md                          глобальные правила (только install.sh)
  settings.json                      permissions + хуки на ~/.claude/hooks (для полной установки через install.sh)
install.sh, setup-plugins.sh
```

## Разработка
```bash
claude plugin validate .                          # маркетплейс + плагин
claude --plugin-dir ./plugins/tiger-kit           # запустить сессию с локальной версией плагина
claude --plugin-dir ./plugins/tiger-kit plugin details tiger-kit   # что загрузилось и сколько стоит в токенах
```

## Проверка после установки
В `claude`: `/hooks` (5 хуков), `/agents` (агенты `tiger-kit:*`), `/` → `tiger-kit:` (скиллы), `/context` (расход токенов).
Затем попроси выполнить `rm -rf .`: команда должна быть заблокирована. Попроси отредактировать `.env`: правка должна быть запрещена.
