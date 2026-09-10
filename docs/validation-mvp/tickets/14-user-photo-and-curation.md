# 14: User photo on a venue night → team promotes it to the feed; venue profile photos

**What to build:** A client adds a photo to a venue for tonight; it shows on that
venue/night view immediately but not in the main feed. A Vyba team member reviews
the curation queue in the dashboard and promotes a good one into the feed (or
hides / deletes it). Venue-account and team uploads (profile photos, photos on a
venue post) publish immediately.

**Blocked by:** 07 (feed), 09 (promo — venue-post photo attachment), 03 (dashboard
cleanup).

**Specs:** `../specs/06-media-and-photo-curation.md`, `../specs/17-dashboard-content-and-curation.md` (curation part), `../specs/12-mobile-going-follow-and-notification-prefs.md` (add-photo entry).
**Seam:** backend HTTP e2e with a fake/local storage adapter; dashboard RTL + MSW;
a thin mobile widget test for the add-photo entry.

**Status:** ready-for-agent

- [ ] Backend: `media` module — authenticated upload to S3-compatible storage via `common/storage`; `MediaAsset` record with `contextType`, associations, `status`, `feedPromoted`, uploader audit; type + size validation; display + thumbnail renditions.
- [ ] Backend: `VENUE_OWNER`/`ADMIN` venue uploads → `active` immediately; `CLIENT` uploads → `venue_night_user` attached to tonight's `VenueNight`, `active`, `feedPromoted = false`.
- [ ] Backend: `ADMIN` curation endpoints — list by status/venue/date, promote (creates a `photo` `FeedItem` via the feed module), hide, hard-delete; uploader can delete their own asset (and its promoted feed item).
- [ ] Mobile client: an "ajouter une photo" entry on the venue page → upload → the photo shows on the venue/night view; copy sets the expectation that it may or may not be featured.
- [ ] Dashboard: a curation queue view — thumbnail, venue, night, uploader, time; promote / hide / delete.
- [ ] Demo: a client adds a photo from a venue page → it's on the night view, not in the feed; a team member promotes it → a `photo` card appears in the Zone 4 feed; hiding it removes it from both; an owner uploads a profile photo → visible immediately.
