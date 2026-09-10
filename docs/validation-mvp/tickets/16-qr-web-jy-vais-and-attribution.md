# 16: QR web — phone verify + "J'y vais" on web + app prompt + web attribution

**What to build:** On the web venue page, tapping "J'y vais" runs a quick phone →
code → verified-session flow, then marks the intent so the count increments. An
unobtrusive "get the app" prompt appears only after a completed action. The
`src` / `venue` params captured in ticket 12 are carried through the landing and
signup events into the analytics core.

**Blocked by:** 04 (phone-OTP backend), 08 ("J'y vais"), 12 (QR web public read),
11 (analytics core).

**Specs:** `../specs/14-qr-web-surface.md`, `../specs/01-backend-phone-otp-auth.md` (web session), `../specs/07-attribution-and-analytics.md` (web as a source).
**Seam:** web route/page integration with MSW.

**Status:** ready-for-agent

- [ ] Web: "J'y vais" on the venue page → if a session exists, call the backend `going` mark; if not, a phone-entry → code → verify flow (backend ticket 04, including the 18+ confirmation on first verify) → persist a secure session → complete the mark.
- [ ] Web: party size optional; identity private by default; after marking, the count reflects it.
- [ ] Web: the verified web session is the same account as the app for that phone number (backend guarantees this) and persists so a second action needs no new code.
- [ ] Web: an unobtrusive "Télécharge l'app pour suivre tes lieux et recevoir les infos" prompt (Play Store link) appears only after a completed "J'y vais" — never a blocking interstitial, never before value.
- [ ] Web: the captured `src`/`venue`/`pid`/`campaign` are sent with `qr_landing_opened` and with signup via the analytics-core endpoints; `acquisition_venue_id` defaults to the QR's venue for `src=qr`.
- [ ] Demo: open `/{venue}?src=qr&venue=V1`, tap "J'y vais" → phone → code → the count goes up; a second "J'y vais" in the same session needs no code; the signup carries `src=qr, venue=V1`; the app-download prompt shows only after the mark.
