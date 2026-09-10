# 11: Attribution + analytics core (app + backend)

**What to build:** The measurement backbone. Structured acquisition params flow
from entry points into raw landing/acquisition events; the acquisition source is
snapshotted onto the user at signup without collapsing history; the app emits the
core event taxonomy through a server-side PostHog proxy that strips PII;
`active_zone` is derived from meaningful Zone 4 actions and kept distinct from
`acquisition_zone`.

**Blocked by:** 04 (sign-in), 07 (feed — a primary event source). Web attribution
is added as a source in ticket 16; this ticket does not depend on the web surface.

**Specs:** `../specs/07-attribution-and-analytics.md`.
**Seam:** backend HTTP e2e with a fake PostHog client capturing forwarded payloads.

**Status:** ready-for-agent

- [ ] Backend: `attribution` module — capture `?src=…&venue=…&pid=…&campaign=…`; store raw `LandingEvent`; on signup, match the anonymous client id, record an `AcquisitionEvent`, and write a first-touch snapshot to `User` (`acquisitionSource`, `acquisitionVenueId?`, `acquisitionPromoterId?`, `acquisitionCampaignId?`, `acquisitionZone`, `firstLandingAt`, `signupAt`). Raw events retained. Confirm first-touch vs last-touch in review.
- [ ] Backend: `analytics-proxy` — clients POST events; the proxy validates against the taxonomy, attaches the server-known internal user id, drops non-allowed properties (strips any `phone`), forwards to PostHog (EU project); keys server-side only; backend modules emit through the same path.
- [ ] Backend: the core event taxonomy (`feed_opened`, `feed_item_viewed`, `venue_viewed`, `venue_followed`, `going_marked`, `going_cancelled`, `promo_viewed`, `promo_created`, `event_viewed`, `post_created`, `post_created_organically`, `post_created_founder_assisted`, `qr_landing_opened`, `app_install_started`) with a stable schema.
- [ ] Backend: `active_zone` set/updated on a meaningful action involving a Zone 4 venue or a Zone 4 "J'y vais"; the "meaningful action" list is one shared constant used by both the proxy and first-party queries; `acquisition_zone` and `active_zone` never conflated.
- [ ] Backend: first-party aggregate queries for the metrics dashboard (Zone 4 WAU, organic vs assisted per venue per week, going per night, active venues) read `FeedItem` / `Going` / events — not PostHog.
- [ ] Mobile: capture install-referrer / deep-link attribution params on first run, hold until signup, forward on verify; emit the core events from the existing screens (feed, venue, going, follow).
- [ ] Demo (e2e): a signup after a `?src=qr&venue=V1` landing has `acquisitionSource=qr`, `acquisitionVenueId=V1`, `acquisitionZone=zone_4`, `activeZone` unset; a Zone 4 `venue_viewed` flips `activeZone`; a forwarded payload contains an internal id and no phone number; a client sending a `phone` property has it stripped.
