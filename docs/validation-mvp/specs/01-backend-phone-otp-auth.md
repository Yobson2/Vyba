# Spec: backend-phone-otp-auth

> Ready-for-agent spec. Part of the Vyba validation MVP critical path (unit 1 of 4).
> Source of truth: `docs/validation-mvp/VYBA_VALIDATION_MVP_SPEC.md` §7, §19; `docs/adr/0003-phone-otp-as-sole-identity.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

A person in Abidjan wants to use Vyba — follow a venue, mark "J'y vais", get
tonight's digest. They identify themselves the way everyone in the market does: by
phone number. They do not want to invent a password or hand over an email, and they
may first meet Vyba on the QR web page and only later install the app — expecting to
be the same person in both places.

The backend today only knows how to authenticate an email + password, carries a
role vocabulary from the original template's domain (`CHEF_ZONE`, `MEMBRE` —
"families", "zones"), and has no concept of a one-time code or an SMS provider.

## Solution

The backend authenticates users by **phone number + one-time code (OTP)** and
nothing else. A user requests a code for their phone number, receives it by SMS
(with a WhatsApp fallback path available), submits it, and receives a JWT access
token + refresh token. The same phone number always resolves to the same account,
whether the caller is the mobile app or the web surface. A verified web session
persists so the code is not re-requested within a session.

The internal admin dashboard keeps its existing email + password login — it is a
staff tool, not an end-user surface, and is out of scope for this change except
where the shared role vocabulary is touched.

## User Stories

1. As a new user, I want to request a login code by entering my phone number, so that I can start using Vyba without creating a password.
2. As a new user, I want the code delivered by SMS within seconds, so that I can continue without waiting or switching apps.
3. As a returning user, I want entering my phone number and the current code to log me back into my existing account, so that my follows and "J'y vais" history are still there.
4. As a user who first used the QR web page, I want installing the app and verifying the same phone number to land me in the same account, so that nothing I did on the web is lost.
5. As a user, I want a wrong or expired code to be rejected with a clear reason, so that I know whether to retry or request a new code.
6. As a user, I want to request a new code if the first never arrives, so that a failed SMS does not lock me out.
7. As a user, I want a short cooldown between code requests, so that I understand the system is working and not silently ignoring me.
8. As a user, I want my access token refreshed automatically via a refresh token, so that I am not asked to re-verify constantly.
9. As a user, I want to be asked to confirm I am 18 or older the first time I verify, so that the nightlife context is handled correctly, and I want that confirmation remembered.
10. As a user on the web surface, I want my verified session to persist for the session duration, so that marking "J'y vais" does not trigger another code.
11. As a venue owner, I want an account the Vyba team created for me (bound to my venue) to log in with my phone number and a code, so that I do not go through any self-serve signup.
12. As the Vyba team, I want to provision a venue-owner account by phone number and role, so that onboarding a venue in person results in a working owner login.
13. As a platform operator, I want OTP requests from a single phone number or client to be rate-limited, so that the SMS bill and abuse surface stay bounded.
14. As a platform operator, I want OTP codes, tokens and phone numbers kept out of all logs, so that a leak of logs is not a leak of credentials or PII.
15. As a platform operator, I want a failed SMS send to be observable (metric / structured event without the code), so that a provider outage is visible before it looks like weak demand.
16. As a developer, I want a single SMS-provider interface with the Africa-focused provider as the implementation, so that swapping providers or adding the WhatsApp fallback does not touch auth logic.
17. As a developer, I want the role vocabulary to be `ADMIN` / `VENUE_OWNER` / `CLIENT`, so that guards and tokens express Vyba's actual actors.
18. As a developer, I want auth to expose the current principal (user id, role, phone) to downstream modules, so that `venue-night`, `going` and `feed` can enforce ownership and `assisted` rules.
19. As a security reviewer, I want the JWT `exp` to be short and the refresh flow to be the only way to extend a session, so that a stolen access token has a small window.
20. As a returning user whose account was deactivated, I want verification to fail cleanly, so that a disabled account cannot obtain tokens.

## Implementation Decisions

**Modules touched**

- `auth` module — reworked. New surface: request-code, verify-code, refresh, (optional) logout/session-invalidate.
- `users` module — `User` becomes phone-first: `phone` (unique, required, E.164), no `password`, name fields optional, `role`, `isActive`, plus `ageConfirmedAt` and an acquisition snapshot placeholder (populated by the `attribution` unit later — nullable now).
- Shared role constant — replace `ADMIN` / `CHEF_ZONE` / `MEMBRE` with `ADMIN` / `VENUE_OWNER` / `CLIENT`; fix the role metadata copy. Default role for a self-verified user is `CLIENT`.
- Redis (`common/redis`) — OTP code store.
- A new SMS-provider abstraction under shared infrastructure.

**OTP flow**

- Request: input is a phone number (validated + normalised to E.164). A numeric code (6 digits) is generated, stored in Redis keyed by phone with a TTL (recommended 5 minutes), and dispatched via the SMS provider. Response never contains the code and does not reveal whether the number is a known user.
- Verify: input is phone + code + (on first-ever verify) an age-confirmation boolean. On match: consume the code, get-or-create the `User` by phone, set `ageConfirmedAt` if provided and not set, issue tokens. On mismatch: increment an attempt counter; after N attempts (recommended 5) invalidate the code and require a new request.
- Resend: allowed after a cooldown (recommended 60s); requesting a new code supersedes the previous one (old code no longer valid — "duplicate-code behaviour" is: latest wins).
- Rate limits: per-phone (e.g. max 5 requests / 15 min) and per-IP/client, enforced in Redis. Exceeding returns a 429-style typed error.

**Tokens & sessions**

- Keep the existing JWT access + refresh mechanism and `generateTokens` shape (payload carries `userId`, `role`). Access token short-lived; refresh token longer-lived; refresh endpoint rotates the access token.
- Web session persistence is achieved by the client holding the refresh token in a secure session store; the backend contract is just "refresh works". No server-side session table required for v1.

**SMS provider abstraction**

- One interface: `send(phoneE164, message)` → delivery result (accepted / failed + reason code, no PII in the reason).
- Primary implementation: the selected Africa-focused provider (config-driven credentials + sender ID "Vyba").
- A `WhatsAppOtpProvider` implementing the same interface is a stub/interface now, wired only after operational verification — the abstraction must not assume SMS.
- A `FakeSmsProvider` for tests and local dev that records the last code per phone (this replaces the `USE_MOCK_AUTH` shortcut for auth; mock-auth is not extended).

**Identity resolution**

- Phone number (E.164) is the natural key. Get-or-create on verify. Installing the app and verifying the same number returns the same `User` row — no linking logic, no merge.

**Authorization surface for downstream units**

- The auth guard populates the request principal with `{ userId, role, phone }`.
- A `@Roles(VENUE_OWNER)` / `@Roles(ADMIN)` guard usage is available for `venue-night`, `promotions`, editorial, etc.
- Ownership checks (is this principal the owner of venue X?) are the responsibility of the owning module (`venues`/`venue-night`), which reads `userId` from the principal.

**Admin dashboard auth**

- Unchanged (email + password) except that it now uses the new role constant. No OTP for the dashboard.

**Logging / security**

- Phone numbers, codes and tokens must never be logged. The `Logger` lines in the current `auth.service` that log `user.id` on register/login are acceptable; anything with a phone or code is not.
- Follow `docs/security.md` (S-items on auth); validate JWT `exp` server-side; typed domain exceptions (`InvalidCredentialsError` → repurpose as `InvalidOtpError`, add `OtpExpiredError`, `OtpRateLimitedError`, `AccountInactiveError`).

## Testing Decisions

**What a good test looks like here:** it exercises the HTTP surface of the booted
Nest application and asserts observable outcomes — response status, response body
shape, whether a token works on a protected route, whether a second code request is
refused. It never reaches into the Redis client, the token signer, or service
internals.

**Seam:** the backend HTTP API. `supertest` against the booted app (`yarn test:e2e`
is already configured), a throwaway PostgreSQL, and fake adapters: `FakeSmsProvider`
(exposes the last code so the test can "receive" it), plus stubs for any other
external service pulled in transitively.

**Modules under test:** `auth` end-to-end, with `users` and the role constant
exercised through it.

**Prior art:** `users.controller.spec.ts` exists as a Nest testing-module test —
this unit should establish the higher e2e seam (`test/*.e2e-spec.ts`) that units
2–4 will reuse. Mirror the existing module conventions from `docs/backend.md`.

**Representative cases:** request → receive → verify → get tokens → call a protected
route successfully; wrong code rejected; expired code rejected; resend before
cooldown refused; resend after cooldown supersedes old code; rate limit trips after
N requests; same phone verified twice returns the same user id; refresh rotates the
access token; deactivated account cannot verify; first verify records age
confirmation, second verify does not require it.

## Out of Scope

- The mobile and web client UIs for entering a phone/code (separate units).
- The actual contract with a specific SMS vendor, sender-ID registration, and the
  three-network deliverability test (operational, tracked in the MVP spec §14.1 / §20.2).
- WhatsApp OTP implementation beyond the interface.
- Proximity / device signals.
- Acquisition attribution capture (unit: attribution-and-analytics) — `User` has a
  nullable placeholder only.
- Any dashboard auth change beyond adopting the new role constant.
- Account deletion / data-export endpoints (privacy unit).

## Further Notes

- ADR-0003 records why phone-OTP is the sole primitive and why the dashboard is
  exempt.
- The old email/password `login`/`register` paths and `bcrypt` usage are removed,
  not deprecated-in-place — nothing in the validation product calls them.
- Downstream units 2–4 all assume this unit's principal shape and role names; build
  this first.
- SMS cost per successful verification is a tracked budget line (MVP spec §18.2).
