# <Project name>

<!-- Keep this file under ~120 lines. It is loaded into every session in this repo.
     Facts and rules only; procedures belong in .claude/skills/, long docs in docs/. -->

## What this is
<One paragraph: product, target user, how it makes money, current stage (prototype / beta / prod).>

## Stack
<Only deviations from the global default stack, plus exact major versions that matter.
e.g. Next.js 16, Supabase, grammY 1.x, Expo SDK 5x>

## Commands
- Install: `pnpm i`
- Dev: `pnpm dev`            (web on :3000)
- Typecheck: `pnpm typecheck`
- Lint/format: `pnpm lint` / `pnpm format`
- Unit tests: `pnpm test` (single file: `pnpm test path/to/file.test.ts`)
- E2E: `pnpm e2e`
- DB: `supabase start` · new migration `supabase migration new <name>` · types `pnpm db:types`

## Map
- `apps/web` – Next.js app (routes in `app/`, server actions in `app/**/actions.ts`)
- `apps/bot` – grammY bot (handlers in `src/handlers`, one file per feature)
- `packages/db` – generated Supabase types + query helpers
- `supabase/migrations` – SQL migrations (never edit an applied one)
- `docs/` – PRD.md, ARCHITECTURE.md, PLAN.md, plans/, research/, HANDOFF.md

## Conventions
- Data access only through `packages/db`; no raw Supabase calls in components.
- Server-only code imports `server-only`. Env is parsed once in `env.ts` with Zod.
- Every table: RLS enabled + policies in the same migration.
- UI: shadcn/ui components from `components/ui`; no new UI libraries.
- i18n: ru (default), uz, en.

## Gotchas
<!-- Append with /lesson. One line each, imperative. -->
- 

## Current focus
See docs/PLAN.md (milestones) and docs/HANDOFF.md (last session state).
