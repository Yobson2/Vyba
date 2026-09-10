# Spec: dashboard-monitoring-and-metrics

> Ready-for-agent spec. Vyba validation MVP (unit 18) — the validation instrument. Depends on 15, and backend 02, 03, 04, 07.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §13 (surfaces 5–6), §23; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The team needs two read-only views. Operationally, during a given night: which
venues are live, how many people are going where, and where to intervene. And for
the weekly validation review: the gate metrics — Zone 4 WAU, week-4 retention,
organic vs assisted posting, going activity per night — computed from first-party
data so the month-4 decision is a lookup, not a debate. The dashboard has a generic
template dashboard and mock analytics charts; neither answers these questions.

## Solution

One dashboard surface, two views. **VenueNight monitor**: tonight's venues with live
status, going count, recent activity, and a "quiet — nudge" flag. **Validation
metrics**: the §23 gate metrics from first-party queries (backend unit 07), with
links out to PostHog for cohort/funnel detail. Both read-only.

## User Stories

1. As a Vyba team member, I want to see tonight's venues with their live status and going count in one list, so that I know what's happening across Zone 4 right now.
2. As a team member, I want venues that are quiet tonight (not live, no posts, low going) flagged, so that I know where to nudge.
3. As a team member, I want to see each venue's most recent posts and activity inline, so that I can judge engagement without clicking through.
4. As a team member, I want the monitor to refresh (or be easily refreshable), so that it reflects the current state during an evening.
5. As a team member, I want to jump from a venue in the monitor to its provisioning record or its content, so that I can act.
6. As a team member, I want a metrics view showing Zone 4 weekly active users, so that I can track against the ~500 gate.
7. As a team member, I want week-1 / week-2 / week-4 retention, so that I can track against the ≥25% week-4 gate.
8. As a team member, I want organic vs founder-assisted posts per venue per week, so that I can track against the "≥15 of ~30 venues posting organically" gate.
9. As a team member, I want going activity per night over the last weeks, so that I can see whether weekend nights have meaningful intent.
10. As a team member, I want the count of active venues and total content activity, so that I have supply-side context.
11. As a team member, I want the metrics to state their definitions (what "active", "Zone 4", "organic" mean), so that the review isn't a definitions argument.
12. As a team member, I want links to the relevant PostHog dashboards for deeper cohort and funnel analysis, so that I don't rebuild PostHog in the dashboard.
13. As a team member, I want retention segmentable by acquisition source, so that I can see which channel brings retained users.
14. As a security reviewer, I want these views `ADMIN`-only and free of individual PII beyond what's operationally necessary, so that a metrics screen isn't a data-exposure surface.
15. As a developer, I want the metrics view to read first-party aggregate endpoints, not compute from raw rows in the browser, so that it stays fast and consistent with §23.2.

## Implementation Decisions

**Feature**

- One dashboard feature (e.g. `features/insights`) with two views: Monitor and
  Metrics. Read-only — no dialogs, no mutations. TanStack Query against first-party
  aggregate endpoints (backend units 02/03/04/07).

**VenueNight monitor**

- Data: for tonight (Abidjan date), each active venue's `VenueNight` — `isLive`,
  `liveSince`, `goingCount`, recent `FeedItem`s, `postCount`.
- A derived "quiet" flag: not live AND no post today AND going count below a small
  threshold. Sort quiet venues to the top (they're the action list).
- Manual refresh (and/or a modest polling interval while the view is open). No
  websockets.
- Row actions: link to the venue in provisioning (unit 16) and in content (unit 17).

**Validation metrics**

- Reads aggregate endpoints (backend unit 07 provides these):
  - Zone 4 WAU (rolling 7-day, `activeZone = zone_4`, "meaningful action" per the
    locked definition).
  - Retention: week-1 / week-2 / week-4 cohorts, overall and by `acquisitionSource`.
  - Posting: per venue per week, `organic` vs `assisted` counts; a roll-up "N of M
    venues posted organically this week".
  - Going activity per night (last ~8 weeks), highlighting weekend nights.
  - Active venue count, total content activity.
- Each metric card shows its definition inline (short text) and, where useful, a
  small trend (use the dashboard's existing chart components; keep it simple).
- A panel of outbound links to the corresponding PostHog dashboards.
- Against the §23.3 gate thresholds, show current value vs target (e.g. "WAU: 312 /
  ~500").

**Definitions**

- The "meaningful action", "Zone 4", "organic" definitions are rendered from a
  single shared source (mirrors backend unit 07's constants) so the screen and the
  backend never disagree.

**Authorization**

- `ADMIN` only. No per-user drill-down that exposes phone numbers.

## Testing Decisions

**Good test:** RTL + **MSW**. Render the monitor against a mocked "tonight" payload
and assert: live venues show a live badge and `liveSince`; a venue with no activity
and low going is flagged quiet and sorted up; row links point to the right places.
Render the metrics view against mocked aggregate responses and assert: each gate
metric renders its value against its target; retention renders per-source when the
mock includes segments; the definition text is present; PostHog links render.

**Seam:** the dashboard **page integration layer with MSW**.

**Modules under test:** the insights feature's two views.

**Prior art:** the existing `features/analytics` and `features/dashboard` (chart
components, layout) — reshaped, not reused wholesale; `docs/dashboard.md`.

**Representative cases:** monitor with [V1 live/going 20, V2 not live/no posts/going
1] → V1 shows live, V2 flagged quiet and on top; metrics: WAU card "312 / ~500",
week-4 retention "18% / ≥25%", posting "11 / ~15 venues organic this week", going
chart renders weekend nights highlighted; retention by source shows QR vs promoter
vs social when segments are present; all cards show a definition line.

## Out of Scope

- Computing metrics in the browser from raw event rows — read aggregates (backend
  unit 07).
- Rebuilding PostHog's cohort/funnel analysis in the dashboard — link out.
- Editing anything (read-only surface).
- Provisioning and content actions (units 16–17) — only links to them.
- Alerting / scheduled metric emails.
- The month-4 decision itself (that's a human review against MVP spec §23.4; this
  surface informs it).

## Further Notes

- MVP spec §23.2: metric definitions are **locked**; this screen renders them, it
  doesn't get to reinterpret them. Same source as backend unit 07.
- Monitor and metrics are one unit because both are read-only view surfaces on the
  same seam with the same role; they differ in cadence (nightly vs weekly) but not
  in shape.
- This is the surface the founding team looks at in the weekly validation meeting
  (MVP spec §22.4) alongside the qualitative log.
