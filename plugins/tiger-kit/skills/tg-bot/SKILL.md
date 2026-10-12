---
name: tg-bot
description: Scaffold or extend a production-grade Telegram bot with grammY - handlers, conversations, i18n, Postgres sessions, Stars payments, admin tools, webhook/polling, Docker.
argument-hint: "<what the bot does | 'add <feature>'>"
disable-model-invocation: true
---

Bot: $ARGUMENTS

Use the `telegram-engineer` subagent's rules (read ~/.claude/agents/telegram-engineer.md if you are not running as it).

1. **Clarify (max 5 questions):** core user flows; languages (default ru/uz/en); payments (Stars for digital goods, or external for physical); admin needs (stats, broadcast, moderation); hosting (serverless webhook vs always-on). Skip questions already answered in CLAUDE.md/PRD.
2. **Verify current APIs** of grammY and the plugins you will use (Context7 or docs) - do not rely on memory for plugin signatures.
3. **Scaffold** (new bot) in `apps/bot` or the repo root:
   - `src/env.ts` (Zod: BOT_TOKEN, WEBHOOK_SECRET, DATABASE_URL, ADMIN_IDS)
   - `src/bot.ts` composition: error boundary, i18n, session (Postgres adapter), rate limiter, then feature composers
   - `src/handlers/<feature>.ts`, `src/conversations/`, `src/keyboards/`, `locales/{ru,uz,en}.ftl`
   - `src/server.ts` (Hono) exposing `/telegram/<secret>` webhook + `/health`; `src/polling.ts` for dev
   - `users` table migration (telegram_id, language, is_blocked, referred_by, created_at) + payments table if needed
   - admin: `/stats`, `/broadcast` via a throttled job (respect 429 retry_after), only for ADMIN_IDS
   - Stars payments if needed: invoice -> pre_checkout_query (answer < 10s) -> successful_payment stored idempotently -> entitlement granted; `/refund` for admins
   - Dockerfile + `setMyCommands` script per language
   - tests: handlers fed with fake Updates
4. **Feature mode** (`add <feature>`): new composer + locale keys + tests, wired into bot.ts.
5. **Run it** with a test bot token (ask me for it via env, never paste it in chat history files), walk through the flow, and report what you verified.
