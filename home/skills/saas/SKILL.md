---
name: saas
description: Build or audit the SaaS foundation of a project - auth, organisations, RLS, plans and billing webhooks, entitlements, emails, analytics, error tracking, admin, legal pages.
argument-hint: "new | audit | add <piece>"
disable-model-invocation: true
---

Mode: $ARGUMENTS

Foundation checklist (Next.js + Supabase default stack):
- [ ] Auth: Supabase Auth (email OTP/magic link + Google; Telegram login if the audience is in Telegram), middleware session refresh, protected routes
- [ ] Tenancy: `orgs`, `org_members(role)`, invites; every business table has `org_id` + RLS via membership helper
- [ ] Plans & entitlements: `plans` (limits as JSON), `subscriptions` (provider ids, status, period end), single `can(org, feature)` / `usage(org, metric)` helper used everywhere
- [ ] Billing: Paddle or Lemon Squeezy (merchant of record; works for a seller in Uzbekistan - verify current onboarding rules), checkout link, signed webhook handler, idempotent event table, customer portal link; Telegram Stars if sold inside Telegram; Click/Payme for local customers
- [ ] Usage metering + limits enforced server-side (AI tokens, renders, messages)
- [ ] Transactional email (Resend + React Email): welcome, invite, receipt/dunning, magic link
- [ ] Analytics (PostHog: signup, activation event, paywall view, purchase) and Sentry (web + server)
- [ ] Admin: internal `/admin` gated by role - users, orgs, subscriptions, impersonate (audited)
- [ ] Marketing: landing, pricing page from `plans`, SEO meta/OG, sitemap; legal: terms, privacy, refund policy
- [ ] Ops: rate limiting, background jobs, backups, status/health endpoint, feature flags

Modes
- **new**: check `docs/ARCHITECTURE.md`, then implement the checklist in order as separate commits, pausing after auth + tenancy, and after billing, for me to test.
- **audit**: inspect the repo against the checklist and output a table `item | status (done/partial/missing/risky) | evidence path | fix effort`, then ask what to implement.
- **add <piece>**: implement one checklist item end-to-end with tests.

Always verify provider APIs (Paddle/Lemon Squeezy/Resend/PostHog) against current docs before coding, and use sandbox/test mode keys only.
