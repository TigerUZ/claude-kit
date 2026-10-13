---
name: mini-app
description: Scaffold or extend a Telegram Mini App (Vite + React + TS) with Telegram theming, native buttons, server-side initData verification and session exchange.
argument-hint: "<what the mini app does>"
disable-model-invocation: true
---

Mini App: $ARGUMENTS

1. Check the current Telegram Mini Apps SDK package and API (Context7/docs; the @telegram-apps / tma.js packages have been renamed and re-versioned - do not trust memory) and the latest Bot API Mini App features.
2. Scaffold `apps/miniapp`: Vite + React + TS + Tailwind (+ shadcn/ui), router, SDK init with a mock environment for running outside Telegram in dev.
3. Telegram integration:
   - Theme params -> CSS variables -> Tailwind tokens; respect light/dark and safe areas / viewport changes.
   - Native BackButton and MainButton wired to the router and the primary action; haptic feedback on key actions.
   - Optional: CloudStorage for small per-user prefs, requestContact / shareMessage where useful.
4. Backend (reuse existing API or add Hono/Next route):
   - `POST /auth/telegram`: verify `initData` HMAC with the bot token, reject if `auth_date` older than ~1h, upsert user, return a session (httpOnly cookie or short JWT).
   - All further API calls authenticated by that session - never by initDataUnsafe fields.
5. Bot wiring: menu button / Main Mini App URL via @BotFather, `web_app` keyboard button, deep link `startapp` parameter handling.
6. Dev loop: `cloudflared tunnel --url http://localhost:5173` (or ngrok), set the HTTPS URL in BotFather for the TEST bot.
7. Deploy to Vercel (static) + API host; add CSP and allow Telegram web clients.
8. Verify: open in Telegram desktop/mobile test bot; list what you checked and what needs a phone.
