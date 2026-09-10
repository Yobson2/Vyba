# Design System — Vyba Lagos Pulse

These rules are **hard constraints** for all UI work across both frontends. A
violation is treated the same as a security-framework violation — fix before
merge. `CLAUDE.md` carries the short version; this file is the full reference.

Tokens: `Vyba-mobile-app/lib/core/theme/*` (Flutter) and
`Vyba-dashboard-admin/src/index.css` (dashboard, Tailwind v4 `@theme`).

## Color Palette

- **Primary**: Electric Indigo `#B0A3FF` — main interactive elements, CTAs
- **Secondary**: Lagos Emerald `#69F6B8` — availability and success states only
- **Tertiary**: Golden Hour `#FFB148` — promotions and VIP only
- **Error**: `#FF6E84`
- **Never use** pure black `#000000` — use tonal dark surfaces from `AppColors`
  (Flutter) or design tokens (dashboard)

## Boundaries & Borders

- **No-line rule**: define boundaries through tonal surface shifts, not 1px borders
- No `border`, `outline`, or `divider` lines on cards, chips, inputs, or containers
- Use layered surface tones (`surfaceContainer`, `surfaceContainerHigh`, etc.) to
  create visual hierarchy

## Corners & Shapes

- No sharp corners — always use rounded radii from `AppRadius` (Flutter) or
  Tailwind `rounded-*` tokens
- Minimum radius: 8px (`AppRadius.sm`). Cards and modals: 12–16px. Pills/chips: 999px

## Shadows & Elevation

- No default Tailwind `shadow` or Material `elevation` — use custom `AppShadows`
  (Flutter) or project-specific shadow tokens
- Shadows should be subtle, tinted with brand colors where appropriate

## Spacing

- 4px grid system — all spacing must be multiples of 4
- Use `AppSpacing` constants (Flutter) or Tailwind spacing scale (dashboard)

## Typography

- Use `AppTypography` tokens (Flutter) or the project's configured font family
  (dashboard)
- Dark backgrounds with light text — ensure WCAG AA contrast (4.5:1 minimum)

## Theme

- **Dark-first**: dark mode is the primary design target, light mode is secondary
- All new UI must look correct in dark mode first, then adapt for light

## Known deviations (fix opportunistically, don't spread)

- The dashboard's shared `data-table-*.tsx` components use `rounded-md border`,
  which breaks the no-line rule. When touching them, migrate to tonal surfaces
  (`bg-muted`, `bg-card`) instead of copying the border pattern into new code.
