---
name: deploy
description: Safe deployment runbook - preflight checks, env var diff, migrations, preview deploy, smoke test, then production only after explicit confirmation, with a rollback plan.
argument-hint: "<target: vercel | railway | fly | vps | eas> [preview|prod]"
disable-model-invocation: true
---

Target: $ARGUMENTS

1. **Preflight**
   - Clean tree, on the intended branch, CI green (`gh pr checks` / `gh run list -L 3`).
   - Local build passes with production settings.
   - Env vars: list names required by the code (parse `env.ts` / `.env.example`) vs names configured on the platform (`vercel env ls`, `railway variables`, `fly secrets list`, `eas env:list`). Report missing ones by name only.
   - Database: pending migrations (`supabase migration list`); are they backward compatible with the currently running code? If not, stop and propose expand/contract.
2. **Preview / staging deploy** and give me the URL. For bots: deploy to the test bot first.
3. **Smoke test** the preview: health endpoint, main user flow (Playwright script or curl), webhook registration for bots (`getWebhookInfo`), error tracking receiving events.
4. **Rollback plan**: write the exact command to revert (Vercel instant rollback / previous image tag / `eas update --republish` / migration down plan).
5. **Production**: ask me for explicit confirmation. Only then deploy, apply migrations in the right order, and re-run the smoke test against production.
6. **Report**: version/commit deployed, URLs, what was verified, anything to watch in Sentry/logs in the next hour.
