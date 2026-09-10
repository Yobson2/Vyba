# 13: Dashboard content composer — editorial + assist mode + organic/assisted split

**What to build:** One dashboard surface for team-managed feed content. The team
publishes `editorial` items (title, body, publish time, expiry, draft state) and
creates content *on behalf of* a venue via an assist path that the backend stamps
`assisted = true`. A per-venue panel shows how much of a venue's recent content
was assisted vs organic, so the team knows who to nudge.

**Blocked by:** 09 (owner promo → feed, i.e. the promo type + create paths), 03
(dashboard cleanup).

**Specs:** `../specs/17-dashboard-content-and-curation.md` (editorial + assist parts), `../specs/03-feed.md`.
**Seam:** dashboard RTL + MSW page integration.

**Status:** ready-for-agent

- [ ] Backend: `ADMIN` editorial-create endpoint → `origin = founder`, `assisted = false`; assist endpoint (promo / venue_update / live_tonight for a venue) → `origin = founder_assisted`, `assisted = true`, `createdBy` = the team member. No client `origin`/`assisted` field on either.
- [ ] Backend: per-venue organic-vs-assisted counts (this week) available (first-party query — ticket 11's aggregates or a small feed query).
- [ ] Dashboard: one feature with an Editorial view (compose form + a list with draft/published/expired status + quick unpublish) and an Assist view (venue picker → content-type switch → type form → publish; the form has no origin control).
- [ ] Dashboard: a per-venue mini-panel "cette semaine — X posts (Y assistés, Z organiques)".
- [ ] Dashboard: a general hide / delete action on feed items reachable from the content lists.
- [ ] All actions `ADMIN`-only.
- [ ] Demo: publish "5 spots chauds ce soir" (scheduled) → appears in the feed at its publish time and expires on schedule; assist-create a promo for a venue that hasn't posted → shows in the feed, backend records `assisted = true`, the venue's panel reads "1 assisté / 0 organique".
