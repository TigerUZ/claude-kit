# Global rules (apply to every project)

## Me
- Experienced full-stack developer. Skip basics; be direct and concrete.
- Talk to me in Russian. Code, identifiers, comments, commits, PRs: English.
- Based in Uzbekistan (UTC+5). Stripe is not available to me as a merchant:
  payments go through Paddle / Lemon Squeezy (global SaaS), Telegram Stars (digital goods in bots), Click / Payme (local UZ).

## Default stack (a project's CLAUDE.md overrides this)
- TypeScript everywhere, pnpm, Node 22+. Zod at every boundary (env, API input, webhooks).
- Web: Next.js (App Router) + Tailwind + shadcn/ui. Standalone API/workers: Hono.
- Data: Supabase (Postgres + Auth + Storage + pgvector). Migrations via `supabase migration new`. RLS on every table.
- Telegram: grammY. Mini Apps: Vite + React. Mobile: Expo (Router + EAS).
- AI: Vercel AI SDK over Anthropic / OpenAI / OpenRouter. Video: FFmpeg (+ Remotion for templated video).
- Tests: Vitest (unit), Playwright (e2e). Errors: Sentry. Analytics: PostHog.

## How to work
- Non-trivial change: read the relevant code first, state the plan in at most 5 bullets, then implement.
  Changes touching 3+ files or a new subsystem: plan mode first.
- Smallest diff that solves the problem. No speculative abstractions, no drive-by refactors, no new deps without saying why.
- Never guess library APIs. If a library may have changed after your training data, check current docs (Context7 or WebFetch) before writing code.
- Done means verified: run typecheck, lint and the relevant tests (or /verify for UI/runtime behaviour). Report exactly what you ran and what you could not verify.
- Two failed attempts at the same problem: stop, list hypotheses with evidence, ask me.
- Use CLIs yourself instead of asking me: gh, supabase, vercel, docker, psql, eas, ffmpeg.

## Context hygiene
- Delegate broad code search, log reading and long test output to subagents; bring back only conclusions.
- Do not paste large files or logs into the conversation; quote the relevant lines with file:line.
- When I run /handoff, keep docs/HANDOFF.md accurate; it is reloaded at session start.

## Safety
- Never read, print or commit secrets (.env*, keys, tokens). Refer to env var names only; keep .env.example current.
- Never without my explicit "yes" in this conversation: force-push, history rewrite on shared branches, DROP/TRUNCATE,
  migrations or deploys against production, `eas submit`, sending real messages/payments.
- Client code gets public values only (NEXT_PUBLIC_*, EXPO_PUBLIC_*). Validate Telegram initData and all webhooks server-side.

## Git
- Conventional Commits (feat:, fix:, refactor:, chore:, docs:, test:). Small, focused commits.
- Branch per task: feat/<slug>, fix/<slug>. Never commit directly to main in repos with a remote.
