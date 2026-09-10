# Spec: mobile-owner-shell

> Ready-for-agent spec. Vyba validation MVP (unit 13) — the unit the "organic posting" gate rides on. Depends on 09, 10, and backend 02, 03, 04, 05, 08.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §10, §23.3; `docs/adr/0001`; `Vyba-mobile-app/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The central validation question is whether venues post without the Vyba team doing
it for them. That is only measurable if owners have a genuinely fast, obvious tool of
their own. The owner shell inherited from the template has five heavy areas
(dashboard, analytics, bookings, promotions, venue management). During validation an
owner should touch four things and publish a useful update in under ten seconds —
everything else is the team's job in the dashboard.

## Solution

Reduce the owner shell to four actions: see tonight's going count, tap "on est live
ce soir", create a promotion, see basic activity. Plus an owner-home value panel
("84 vues cette semaine · 31 J'y vais") that makes the benefit of posting tangible
before any money is involved. Analytics, booking management and venue-profile editing
are removed from the owner app (they live in the dashboard, units 16–18).

## User Stories

1. As a venue owner, I want to open the app and immediately see how many people are going tonight, so that I can prepare.
2. As a venue owner, I want rough party sizes for tonight, so that I have a sense of group bookings without confirming anything.
3. As a venue owner, I want one tap to mark my venue live for tonight, so that it takes seconds.
4. As a venue owner, I want one tap to set tonight's headline / DJ, so that people know what's on.
5. As a venue owner, I want to create a promotion in a few seconds — a short title, a description, an optional photo — so that an offer reaches people deciding tonight.
6. As a venue owner, I want my promotion to appear in the feed and on my venue page, so that it's seen.
7. As a venue owner, I want to see basic activity for my venue — recent posts, views this week, "J'y vais" this week, follower count — so that I can tell whether Vyba is doing anything for me.
8. As a venue owner, I want that value panel front and centre on my home screen, so that the reason to keep posting is obvious.
9. As a venue owner, I want my posts recorded as mine (not assisted), so that my genuine activity counts as organic.
10. As a venue owner, I want to publish a useful update in under ten seconds start to finish, so that it never feels like a chore.
11. As a venue owner, I want an optional one-tap "prévenir ceux qui viennent ce soir" broadcast, so that I can tell tonight's crowd about a change — used sparingly.
12. As a venue owner, I want to be stopped from sending a second broadcast the same night, so that I don't burn my audience.
13. As a venue owner, I want the shell to only show me these four things, so that I'm not lost in tools I don't need.
14. As a venue owner, I want everything in French, so that it's usable.
15. As a developer, I want owner actions as Riverpod notifiers with explicit states, so that "posting" success/failure is modelled.
16. As a platform operator, I want `post_created` (and its organic/assisted split) and `promo_created` emitted from owner actions, so that organic posting is measured.
17. As the Vyba team, I want profile editing and analytics absent from the owner app during validation, so that the owner surface stays minimal and the team keeps control.

## Implementation Decisions

**Modules touched**

- `features/home` — owner shell navigation reduced to: Accueil (value panel + go-live
  + headline), Promo (create), Activité (basic list). Three tabs or one home + a
  couple of actions — keep it to four *actions*, not four tabs necessarily.
- `features/owner_dashboard` — repurpose as the owner "Accueil": going count + party
  sizes (from backend unit 04), the value panel (views / J'y vais / followers from
  units 07/05), the "on est live ce soir" toggle and headline (backend unit 02).
- `features/promotions` — keep `create_promotion_page`, make it fast (title,
  description, optional photo via `media` unit 06); wire to the backend `feed`
  create-promo path so `origin = venue`, `assisted = false`.
- Owner broadcast — a single action calling the backend `notifications` broadcast
  endpoint (unit 08); the client shows the once-per-night limit state.
- `features/owner_analytics`, `features/owner_bookings`, `features/venue_management`
  — already unrouted in unit 09; confirm they're not referenced by the owner shell.

**Owner "Accueil"**

- Tonight: going count (poll-on-view), rough party-size summary, "on est live"
  toggle (idempotent), headline field.
- Value panel: this week's views, this week's "J'y vais", follower count — plain
  numbers, optionally a small week-over-week delta. No charts.
- The panel is the emotional core of the "keep posting" hypothesis (MVP spec §10.1)
  — it must be prominent, not buried.

**Create promotion**

- Minimal form: title (short), description, optional single photo. Publish → appears
  in feed + venue page. Target < 10s including the tap to open.
- A one-tap "on est live ce soir" and "quick update" path from Accueil covers the
  non-promo cases.

**Broadcast**

- Optional, from Accueil or the venue's tonight view: short message → sends to
  tonight's opted-in "going" users (backend handles the recipient intersection).
  Second attempt the same night shows "déjà envoyé ce soir".

**Provenance**

- All owner-created content goes through endpoints that stamp `origin = venue` /
  `assisted = false` from the authenticated owner principal. The client never sends
  an `assisted` field.

**Analytics**

- Emit `post_created` + `post_created_organically`, `promo_created` on owner actions.

**Design**

- Functional and fast, not the consumer design pass. Clear, dark, tokenised — but
  the investment goes into units 11/12/14, not here (MVP spec §17).

## Testing Decisions

**Good test:** drives the owner action notifiers with fake datasources and asserts
observable outcomes — toggling "on est live" calls the backend once and reflects a
live state; creating a promo calls the feed create-promo path and returns to Accueil
with the item listed; a second broadcast the same night surfaces the limit state;
the value panel renders the numbers from its datasource. A widget test on Accueil
asserts the value panel is present and shows the going count.

**Seam:** the **notifier ↔ use case** boundary with fake datasources; one Accueil
widget test.

**Modules under test:** `features/owner_dashboard` (as Accueil), `features/promotions`
(create), the broadcast action.

**Prior art:** existing `features/owner_dashboard` and `features/promotions`
notifier/state code; `docs/mobile.md` conventions.

**Representative cases:** "on est live" toggle on → single backend call, live state;
toggle again → idempotent; create promo (title + desc) → feed create call, item in
Activité; create promo with a photo → media upload then feed call; broadcast once →
sent; broadcast twice → "déjà envoyé ce soir"; Accueil shows going count + value
panel numbers; owner shell exposes no analytics/booking/profile-edit navigation.

## Out of Scope

- Detailed analytics, booking management, venue-profile editing — dashboard only
  (units 16–18).
- The going aggregate, milestones (backend unit 04).
- Broadcast delivery (backend unit 08); this unit authors + triggers.
- The consumer design pass.
- Owner onboarding / account creation — done by the team in the dashboard (unit 16);
  the owner just signs in (unit 10).
- Multi-venue owners managing several venues — assume one venue per owner for
  validation unless the data model already trivially supports the list.

## Further Notes

- MVP spec §10.1: the "will venues keep posting?" hypothesis is explicit and
  falsifiable. This unit is the instrument — the value panel and the <10s create
  path are load-bearing, not polish.
- §23.3: "≥15 of ~30 venues posting organically every week" is measured off the
  `origin = venue` content this unit produces.
