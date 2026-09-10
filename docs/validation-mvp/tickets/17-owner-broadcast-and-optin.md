# 17: Owner broadcast to tonight's "going" crowd + per-venue opt-in

**What to build:** A client opts in to a specific venue's announcements (a choice
separate from following it). The venue owner can send one short broadcast per night
to tonight's opted-in "going" users. A second attempt the same night is refused.

**Blocked by:** 15 (notifications infrastructure), 08 ("J'y vais" recipients).

**Specs:** `../specs/08-notifications.md` (broadcast), `../specs/13-mobile-owner-shell.md`, `../specs/12-mobile-going-follow-and-notification-prefs.md` (opt-in).
**Seam:** backend HTTP e2e (recipient intersection, once-per-night limit) with the
fake FCM sender; mobile notifier↔usecase.

**Status:** ready-for-agent

- [ ] Backend: `VenueBroadcastOptIn` record `(userId, venueId)` — independent of `Follow`.
- [ ] Backend: owner broadcast endpoint (`VENUE_OWNER`, own venue) — short message, length-capped, no arbitrary payload; recipients = tonight's active `Going` for the venue ∩ opted-in ∩ broadcast-allowing prefs; deep-links to the venue.
- [ ] Backend: rate limit — one successful broadcast per venue per night (via `SentNotification` / a Redis guard); a second returns a typed "déjà envoyé ce soir".
- [ ] Mobile client: "recevoir les infos de ce lieu" toggle on the venue page + on the preferences screen; explicitly separate from the follow toggle.
- [ ] Mobile owner: a "prévenir ceux qui viennent ce soir" action; shows the "déjà envoyé ce soir" state after one send.
- [ ] Demo: client opts into venue A (without following it), marks "J'y vais" at A tonight; the owner of A sends a broadcast → the client receives it (fake FCM records it); the owner tries again → refused; a client who follows A but didn't opt in receives nothing.
