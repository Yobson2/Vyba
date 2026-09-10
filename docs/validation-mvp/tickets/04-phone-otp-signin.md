# 04: Phone-OTP sign-in, end to end

**What to build:** A person installs the app, enters their phone number, receives
a one-time code, enters it, and is signed in — landing in the client shell (or the
owner shell if the account is a `VENUE_OWNER`). The session survives an app
restart and refreshes itself. First sign-in asks for an 18+ confirmation. This is
one vertical slice: backend OTP + mobile screens + session, not two tickets.

**Blocked by:** 01 (backend domain reset), 02 (mobile cleanup).

**Specs:** `../specs/01-backend-phone-otp-auth.md`, `../specs/10-mobile-auth-and-app-shell.md`; `../../adr/0003-phone-otp-as-sole-identity.md`.
**Seam:** backend HTTP e2e (supertest, `FakeSmsProvider` exposing the code) — this
ticket **establishes** that e2e harness; mobile auth notifier↔usecase with a fake
datasource + one OTP-screen widget test.

**Status:** ready-for-agent

- [ ] Backend: request-code endpoint stores a 6-digit code in Redis with a TTL, dispatches via an SMS-provider interface (`FakeSmsProvider` in tests/dev), never returns the code, doesn't reveal whether the number is known.
- [ ] Backend: verify-code endpoint consumes the code, get-or-creates the `User` by phone, records `ageConfirmedAt` on first verify, issues JWT access + refresh.
- [ ] Backend: resend honours a cooldown; a new request supersedes the old code; N wrong attempts invalidate the code; per-phone and per-IP rate limits return a typed error.
- [ ] Backend: refresh endpoint rotates the access token; a deactivated account cannot verify. OTPs/tokens/phone numbers never logged.
- [ ] Backend: the reusable `*.e2e-spec` harness (booted app, throwaway Postgres, fake adapters, a helper to obtain CLIENT/OWNER/ADMIN tokens) exists and is green.
- [ ] Mobile: phone-number screen → request code; OTP screen → verify (+ 18+ checkbox on first sign-in); French error messages mapped from backend typed errors; resend countdown.
- [ ] Mobile: tokens in secure storage, never logged; `AuthInterceptor` uses the real refresh endpoint (queued-401 refresh-and-retry).
- [ ] Mobile: auth state union drives routing — `authenticated(client)` → client shell, `authenticated(owner)` → owner shell, `unauthenticated` on a protected route → phone screen; cold start restores the session.
- [ ] `USE_MOCK_AUTH` defaults to false; the mock path is isolated.
- [ ] Demo: on a device/emulator, enter a phone, read the code from the fake-SMS/log, sign in, see the (empty) client shell; kill and relaunch → still signed in.
