# 18: Validation metrics + VenueNight monitor dashboard

**What to build:** Two read-only dashboard views. The **monitor** shows tonight's
venues — live status, going count, recent activity — and flags quiet venues to
nudge. The **metrics** view shows the §23 validation gates (Zone 4 WAU, week-4
retention, organic vs assisted posting, going activity per night) from first-party
data against their targets, with links out to PostHog for cohort/funnel detail.

**Blocked by:** 11 (analytics core — the aggregates), 09 (promo/organic content),
08 ("J'y vais" data), 03 (dashboard cleanup).

**Specs:** `../specs/18-dashboard-monitoring-and-metrics.md`; `../VYBA_VALIDATION_MVP_SPEC.md` §23.
**Seam:** dashboard RTL + MSW page integration.

**Status:** ready-for-agent

- [ ] Backend: first-party aggregate endpoints (from ticket 11) — Zone 4 WAU (rolling 7-day, `activeZone = zone_4`, meaningful-action list), retention week-1/2/4 overall and by `acquisitionSource`, organic vs assisted posts per venue per week + a "N of M venues organic this week" roll-up, going per night (last ~8 weeks), active venue count, content activity.
- [ ] Backend: a "tonight" endpoint — per active venue: `isLive`, `liveSince`, `goingCount`, recent `FeedItem`s, `postCount`, and a derived "quiet" flag (not live + no post today + low going).
- [ ] Dashboard: Monitor view — tonight's venues, quiet ones sorted to the top; manual refresh (and/or a modest poll while open); row links to the venue in provisioning and in the content composer.
- [ ] Dashboard: Metrics view — one card per gate metric showing value vs §23.3 target (e.g. "WAU: 312 / ~500"), each with its locked definition inline (shared source with the backend); a small trend where useful; a panel of PostHog dashboard links; retention segmentable by source.
- [ ] Both views `ADMIN`-only; no per-user drill-down exposing phone numbers; metrics read aggregates, not raw rows in the browser.
- [ ] Demo: with seeded data, the monitor shows a live venue and flags a quiet one on top; the metrics view renders each gate against its target, the organic/assisted roll-up, the going-per-night chart with weekends highlighted, and retention split by QR / promoter / social.
