# Spec: mobile-auth-and-app-shell

> Ready-for-agent spec. Vyba validation MVP critical path (unit 10). Depends on 09 (mobile cleanup) and 01 (backend phone-OTP auth).
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §6.1, §7, §16; `docs/adr/0003-phone-otp-as-sole-identity.md`; `Vyba-mobile-app/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The mobile app needs a working identity: a person enters their phone number, gets a
code, and lands in the right shell (client or owner) with a session that survives
app restarts and refreshes itself. It also needs the app-lifecycle plumbing that
has to exist before notifications and attribution can work: registering a push token
after login, and routing a tapped notification or a deep link to the right screen.

Today the app has phone/OTP use cases and an OTP screen from the template, wired to
a mock; no real backend call, no session persistence contract with the real API, no
push token registration, no deep-link routing.

## User Stories

1. As a new user, I want to enter my phone number and receive a code, so that I can sign in without a password.
2. As a user, I want to enter the code and be signed in, so that I reach the app.
3. As a user, I want a clear, French error if the code is wrong or expired, so that I know whether to retry or resend.
4. As a user, I want a "resend code" option that respects the cooldown, so that a missing SMS isn't a dead end.
5. As a user, I want to confirm I'm 18 or older on my first sign-in, so that the nightlife context is handled, and to not be asked again.
6. As a user, I want to stay signed in after closing the app, so that I don't re-verify every time.
7. As a user, I want my access token refreshed silently, so that I'm not interrupted mid-session.
8. As a user whose session has truly expired, I want to be returned to the phone-number screen, so that I can sign back in cleanly.
9. As a client, I want to land in the client shell after signing in, so that I see the feed.
10. As a venue owner, I want to land in the owner shell after signing in, so that I see my venue tools.
11. As a user, I want to sign out from settings, so that I can leave the account on a shared device.
12. As a user, I want my push notifications to work after I sign in, so that I get the digest and reminders (their content is other units).
13. As a user, I want tapping a notification to open the relevant screen (feed / a venue), so that the notification is useful.
14. As a user who arrived via a QR or promoter link and then installed the app, I want that source captured, so that attribution is correct (the send is the attribution unit; the capture-on-first-run is here).
15. As a developer, I want a single auth notifier exposing a Freezed state union (initial / codeRequested / authenticated / unauthenticated / error), so that the router and screens react to one source of truth.
16. As a developer, I want the Dio auth interceptor to use the real refresh endpoint, so that 401s are handled by refresh-and-retry.
17. As a security reviewer, I want the access and refresh tokens stored in secure storage and never logged, so that a device compromise is the only way to get them.
18. As a security reviewer, I want `USE_MOCK_AUTH` to default to false and the mock path clearly separated, so that a real build can't ship mock auth.

## Implementation Decisions

**Modules touched**

- `features/auth` — wire `login_with_phone_usecase` (request code) and
  `verify_otp_usecase` (verify + age confirmation) to the real backend; rework the
  auth notifier/state; keep `get_cached_user_usecase`, `logout_usecase`.
- `core/network` — point the `AuthInterceptor` refresh at the real endpoint;
  confirm the queued-401 behaviour against the real token shapes.
- `core/router` — role-based redirect already exists; adjust for the new auth state
  union and ensure the OTP/phone screens are the only unauthenticated entry.
- `core/storage` — secure storage of tokens; a small "session" concept (access +
  refresh + cached user).
- A new lightweight `core/services` concern (or extend an existing one) for **push
  token registration** and **deep-link / notification-tap routing**.
- `core/services/analytics` + a first-run **attribution capture** hook (reads the
  install referrer / a deep link, holds `src/venue/pid/campaign`, hands it to the
  analytics/attribution client on sign-up). The *contract* is backend unit 07; this
  is the client capture + forward.

**Auth flow**

- Screen 1: phone number (E.164 normalisation, French validation copy) → request
  code → state `codeRequested`.
- Screen 2: 6-digit code entry + (first sign-in only) an 18+ confirmation checkbox
  → verify → on success store session, set auth state `authenticated(user)`.
- Resend: visible countdown honouring the backend cooldown; a new request
  supersedes the old code.
- Errors map backend typed errors → French messages (invalid code, expired,
  rate-limited, inactive account).

**Session & routing**

- Auth state union drives the GoRouter `refreshListenable` (pattern already in
  place). `authenticated` with `role == venueOwner` → owner shell; else client
  shell. `unauthenticated` on a protected route → phone screen.
- On cold start: try cached session → refresh → `authenticated` or `unauthenticated`.

**Push token + deep links**

- After `authenticated`, register the FCM token with the backend (`notifications`
  unit endpoint). Refresh on token rotation. Deregister on sign-out.
- A single deep-link/notification-tap handler maps: digest → feed tab; going
  reminder → venue detail; venue broadcast → venue detail. Unknown → feed.

**Attribution capture**

- On first run / via deep link, capture `src`, `venue`, `pid`, `campaign` if
  present; persist until sign-up; on `verify` success, forward to the backend
  attribution endpoint (unit 07). Emit `app_install_started` / `qr_landing_opened`
  as applicable.

**Config**

- `.env`: `BASE_URL`, `USE_MOCK_AUTH=false` default, WhatsApp support number,
  analytics proxy base. No secrets in the client.

## Testing Decisions

**Good test:** drives the auth notifier through request → verify → authenticated,
and asserts the resulting state union and that the router would send a client vs an
owner to the right shell. Uses a fake auth datasource returning canned
success/failure. A widget test renders the phone + OTP screens and asserts: entering
a code calls verify, a backend "expired" error shows the French expired message, the
resend button is disabled during the cooldown, the 18+ checkbox appears only on
first sign-in.

**Seam:** the auth **notifier ↔ use case** boundary with a fake datasource (the
`USE_MOCK_AUTH` provider-override pattern from `docs/mobile.md`), plus one
screen-level widget test for the OTP flow. Not integration against a real backend.

**Modules under test:** `features/auth` (notifier + state), the router redirect
logic, the push-token registration call (asserted via a fake service).

**Prior art:** `test/features/auth/domain/usecases/login_usecase_test.dart` and the
existing auth test structure; the router's existing `ValueNotifier` bridge.

**Representative cases:** request code → `codeRequested`; verify wrong code → `error`
with the mapped message; verify ok (client) → `authenticated`, router → client
shell; verify ok (owner) → owner shell; cold start with valid cached session →
`authenticated` without a network verify; refresh fails → `unauthenticated`, router
→ phone screen; sign out → token cleared, FCM token deregistered; first sign-in
forwards captured `src=qr&venue=X` to the attribution endpoint.

## Out of Scope

- The SMS provider and delivery (backend / ops).
- Notification *content* and scheduling (backend unit 08); this unit only registers
  the token and routes taps.
- Attribution event storage and the PostHog proxy (backend unit 07); this unit
  captures and forwards.
- The feed, venue, going and owner screens (units 11–13).
- Legal/consent screens; only the 18+ checkbox is here.
- Biometric lock, multi-account switching.

## Further Notes

- ADR-0003: phone-OTP is the only path; there is no email or social UI to build.
- The app-shell plumbing (push token, deep links, attribution capture) is grouped
  here because it is session-lifecycle work that has no better home and blocks
  units 08/07's client side.
- Owner shell contents are unit 13; this unit only needs to route an owner *to* it.
