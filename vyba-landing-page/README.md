# Vyba — landing page

Public marketing site for Vyba ("On bouge où ce soir ?"). French only, static
(SSG), dark-first, built on the Vyba design tokens. Distinct from `Vyba-web/`,
the QR-scan acquisition surface (ADR-0004).

**Stack:** Next.js 16 (App Router, Turbopack) · React 19 · Tailwind CSS 4 ·
next-intl (single `fr` locale, no prefix, no cookie) · framer-motion · lucide-react.

## Commands

| Command              | Description                  |
| -------------------- | ---------------------------- |
| `npm run dev`        | Dev server (Turbopack)       |
| `npm run build`      | Production build             |
| `npm run start`      | Serve the production build   |
| `npm run lint`       | ESLint (flat config)         |
| `npm run typecheck`  | TypeScript                   |
| `npm run format`     | Prettier                     |

## Configuration

Copy `.env.example` to `.env.local`. Contact channels and store links are env-driven
and never hardcoded. When one is unset, its CTA renders an inert "bientôt" state
instead of a dead link.

## Structure

```
app/
├── [locale]/              # page.tsx (home), legal/ (confidentialité), error, 404
├── components/
│   ├── device/            # Code-rendered app screens (phone frame, feed cards, screens)
│   ├── layout/            # Navbar (scroll-spy, <dialog> menu), footer
│   ├── motion/            # Reveal + MotionConfig (honours prefers-reduced-motion)
│   └── ui/                # Button, CTA links, section header
├── features/              # hero, problem, journey, going, venues, faq, final-cta
├── lib/                   # siteConfig, motion tokens, metadata
└── globals.css            # Design tokens mirrored from Vyba-mobile-app/lib/core/theme
messages/fr.json           # All copy
```

## Rules

- Product previews are code-rendered with **sample venues** and always carry the
  "lieux et contenus d'exemple" caption. Replace with real screenshots when available.
- Never add testimonials, stats, partner logos or claims that aren't true.
- Design system: `docs/design-system.md` at the repo root (no #000, no 1px borders,
  radius ≥ 8px, token shadows only, semantic brand colours).
