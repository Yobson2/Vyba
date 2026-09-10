# 15: Notifications — device tokens + weekend digest + going reminder + prefs + deep links

**What to build:** The two standing notifications work. On Thursday evening the
opted-in Zone 4 cohort gets a "voici le week-end à Zone 4" push that deep-links to
the feed. Around 20:00 anyone with an active "J'y vais" for tonight gets a
reminder that deep-links to the venue. A preferences screen toggles both. FCM
(Android); a fake sender in tests.

**Blocked by:** 04 (sign-in — token registration), 07 (feed — digest content), 08
("J'y vais" — reminder recipients).

**Specs:** `../specs/08-notifications.md`, `../specs/10-mobile-auth-and-app-shell.md` (token + deep links), `../specs/12-mobile-going-follow-and-notification-prefs.md` (prefs).
**Seam:** backend HTTP e2e + directly-invocable job functions with a fake FCM
sender and an injectable clock; mobile notifier↔usecase.

**Status:** ready-for-agent

- [ ] Backend: `notifications` module — device-token register/refresh/prune; `NotificationPreference` (`weekendDigest`, `goingReminder`, defaults on); `SentNotification` log (type, user, venue?, sentAt, result); FCM sender wrapping `common/firebase`, skipping tokenless users, not failing a batch on one bad recipient.
- [ ] Backend: Thursday ~17:00 Abidjan digest job (BullMQ) — recipients = opted-in cohort users (launch-area active/acquired); content from the feed's top upcoming/weekend items; deep-links to the feed.
- [ ] Backend: daily ~20:00 reminder job — recipients from the `going` unit's "reminder recipients tonight" query ∩ `goingReminder = on`; one grouped notification per user even if several venues; deep-links to the venue.
- [ ] Mobile: register the FCM token after `authenticated`, refresh on rotation, deregister on sign-out; a single deep-link / notification-tap handler (digest → feed, reminder → venue).
- [ ] Mobile: a notification-preferences screen — digest toggle, reminder toggle — mapped to `NotificationPreference`; copy states these are the only notifications Vyba sends.
- [ ] Demo: invoke the digest job with a Thursday clock → the fake FCM sender records sends only to opted-in cohort users, payload references current weekend feed items; invoke the reminder job → only users with an active `Going` tonight and the toggle on; turn the reminder toggle off → excluded on the next run.
