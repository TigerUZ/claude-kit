---
name: landing
description: Build a high-converting, fast, multilingual landing page (Next.js + Tailwind + shadcn) with real copy, SEO, analytics and a lead capture to Telegram or a waitlist.
argument-hint: "<product/business and the desired action>"
disable-model-invocation: true
---

Landing for: $ARGUMENTS

1. **Brief** (ask what is missing, max 5 questions): audience, the one action (buy / book / join waitlist / open bot), offer and price, proof (numbers, testimonials, logos - only real ones), languages (ru/uz/en), brand colours/fonts if any.
2. **Copy first.** Write `content/landing.<lang>.ts`: hero (outcome-focused headline <= 9 words, subhead, CTA), problem, solution/how it works (3 steps), features as benefits, proof, pricing, FAQ (6-8 real objections), final CTA. No lorem ipsum, no invented testimonials.
3. **Design direction.** Use the frontend-design skill / `ui-designer` subagent: choose a distinctive direction (type pairing, one accent colour, layout rhythm), expressed as Tailwind theme tokens.
4. **Build** sections as components; Server Components only; images via next/image; no heavy animation libraries unless justified.
5. **Lead capture:** form -> server action (Zod + honeypot + rate limit) -> store in DB and notify a Telegram chat via the Bot API; or a `t.me/<bot>?start=<utm>` deep link CTA.
6. **SEO/analytics:** metadata + OG image (next/og), hreflang for languages, sitemap/robots, JSON-LD (Organization/Product/FAQ), PostHog or Plausible events on CTA clicks.
7. **Verify:** Playwright screenshots at 390 and 1440 widths (check visually and fix issues), Lighthouse via `npx lighthouse <url> --only-categories=performance,accessibility,seo --quiet` targeting >= 95, then deploy a Vercel preview and give me the URL.
