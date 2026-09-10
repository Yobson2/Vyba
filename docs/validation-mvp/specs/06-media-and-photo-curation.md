# Spec: media-and-photo-curation

> Ready-for-agent spec. Vyba validation MVP (unit 6).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §8, §13.1, §19; `CONTEXT.md` glossary.
> Draft — not yet published to GitHub Issues.

## Problem Statement

Venues need photos on their profile and in the feed. Users take photos on a night
out that are great social proof. But user photos on the main feed are a quality and
safety risk that Vyba can't afford to auto-publish for a 500-user cohort, and there
is no budget to build a moderation platform. The backend has no media handling at
all.

The distinction the product needs: **venue content is trusted operational content
(publishes immediately); user content is community content (curated before it
reaches the main feed).**

## Solution

An upload endpoint stores images in S3-compatible object storage and returns a
stable reference. Venue-account uploads (profile photos, photos attached to a
venue post) are immediately usable. User uploads attach to a `VenueNight`, are
visible on that venue/night view right away, but only enter the main feed when a
Vyba team member promotes them from the curation queue. The team can hide or
hard-delete any image, and every upload carries basic audit info.

## User Stories

1. As a venue owner, I want to upload photos to my venue profile, so that people see what it looks like.
2. As a venue owner, I want to attach a photo to a venue update or promo, so that my post is visual.
3. As a venue owner, I want my uploaded photos to appear immediately, so that there's no wait or review step for me.
4. As a client, I want to add a photo to a venue for tonight, so that I can share what's happening.
5. As a client, I want my photo visible on that venue's night view straight away, so that it feels immediate.
6. As a client, I want to understand my photo may or may not be featured in the main feed, so that expectations are clear.
7. As a client, I want to delete a photo I uploaded, so that I stay in control of my content.
8. As the Vyba team, I want a queue of user-submitted photos with the venue, night and uploader, so that I can review them in the daily editorial pass.
9. As the Vyba team, I want to promote a good user photo into the main feed, so that the feed has a pulse on quiet nights.
10. As the Vyba team, I want to hide or hard-delete any photo, so that bad content is gone fast.
11. As the Vyba team, I want to see who uploaded a photo and when, so that repeat offenders are visible.
12. As a platform operator, I want images served efficiently (reasonable sizes, not full-resolution originals), so that low-end devices and poor connections cope.
13. As a platform operator, I want uploads size- and type-limited, so that storage and abuse stay bounded.
14. As a developer, I want a stable image reference I can store on `Venue`, `FeedItem` and `VenueNight`, so that other modules don't deal with storage directly.
15. As a security reviewer, I want uploads authenticated and attributed, so that anonymous dumping is impossible.

## Implementation Decisions

**Module**

- New `media` module — upload endpoint(s), an `Image` (or `MediaAsset`) record, the
  curation queue endpoints, moderation endpoints. Uses `common/storage` (S3-compatible).

**`MediaAsset` entity**

- `id`, `storageKey`, `uploadedByUserId`, `uploadedByRole` (snapshot),
  `contextType` ∈ { `venue_profile`, `venue_post`, `venue_night_user` },
  `venueId?`, `venueNightId?`, `feedItemId?`, `status` ∈ { `active`, `hidden`,
  `deleted` }, `feedPromoted` (bool, default false), `createdAt`.
- Derived renditions (e.g. a display size + a thumbnail) — generated on upload
  (via `common/queues` if needed) and referenced by convention from the `id`.

**Upload**

- Authenticated. Accepts an image, validates type (jpeg/png/webp) and size (cap,
  e.g. 8 MB), stores original + renditions, returns the `MediaAsset` id/reference.
- `contextType` and associations are set from the request + principal:
  - `VENUE_OWNER` uploading for their venue → `venue_profile` or `venue_post`,
    `status = active` immediately.
  - `ADMIN` uploading for a venue → same, immediate.
  - `CLIENT` uploading → `venue_night_user`, must reference a venue; backend
    resolves tonight's `VenueNight`; `status = active`, `feedPromoted = false`.

**Visibility rules**

- `venue_profile` / `venue_post` assets: usable anywhere the owning module
  references them, immediately.
- `venue_night_user` assets: returned on the venue/night detail view when `status =
  active`; included in the **main feed only** when a `photo` `FeedItem` exists for
  them, which happens only on team promotion.

**Curation queue**

- `ADMIN` endpoints: list `venue_night_user` assets by status / venue / date;
  promote (creates a `photo` `FeedItem` via the `feed` module, sets `feedPromoted =
  true`); hide (`status = hidden`); hard-delete (`status = deleted` + remove from
  storage).
- Uploader can delete their own asset (soft `deleted` + storage removal); if it was
  promoted, the corresponding `photo` `FeedItem` is also removed/hidden.

**Authorization**

- Upload: `VENUE_OWNER` (own venue) or `ADMIN` for venue-context; any `CLIENT` for
  `venue_night_user`.
- Curation / moderation: `ADMIN`.
- Delete own asset: the uploader.

**Audit / safety net (v1 only)**

- Every asset carries uploader id + timestamp. Report/hide/hard-delete is the whole
  safety net — no automated scanning (MVP spec §13.1).

## Testing Decisions

**Good test:** drives upload and the curation endpoints over HTTP and asserts what's
observable — an owner's profile photo is immediately referenceable; a client's night
photo shows on the venue/night view but not in the feed; after `ADMIN` promotes it,
a `photo` item appears in the feed; hide removes it from both; oversized / wrong-type
uploads are rejected; an unauthenticated upload is rejected.

**Seam:** backend HTTP API (unit-1 e2e seam), with a fake/local storage adapter
standing in for S3 (record keys, don't hit a real bucket). Reuse units 1–3 for
auth, venues, feed.

**Modules under test:** `media`, with `feed` observed for the promoted `photo` item.

**Prior art:** units 1–5 e2e specs; `common/storage` usage per `docs/backend.md`.

**Representative cases:** owner uploads profile photo → active immediately; client
uploads night photo → on night view, not in feed; admin promotes → `photo` FeedItem
present, `feedPromoted = true`; admin hides → gone from night view and feed;
uploader deletes own promoted photo → asset and feed item gone; 10 MB upload →
rejected; `.pdf` upload → rejected.

## Out of Scope

- A rich moderation platform, ML content scanning, appeals workflow.
- Video.
- CDN configuration and image-transformation infrastructure choices (ops) — this
  unit just needs "renditions exist and are served"; the exact mechanism is an
  implementation detail.
- The dashboard curation-queue UI (dashboard unit) — this unit provides the API.
- The mobile/web photo capture and upload UI (client units).

## Further Notes

- The trusted/community split is an invariant in `Vyba-dashboard-admin/CONTEXT.md`
  and the MVP spec §13.1.
- Promotion goes through the `feed` module so `origin`/`assisted` stay consistent
  (`feed` decides the origin value for a promoted user photo).
