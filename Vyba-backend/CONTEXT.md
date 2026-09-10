# Vyba Backend — Domain Context

Domain boundaries and invariants for the NestJS API. For commands, module layout,
infrastructure, migrations and conventions, read `../docs/backend.md`. For product
vocabulary, read `../CONTEXT.md`. Code is the source of truth for implementation
detail.

## Role

The single REST API behind both the Flutter app and the QR/mobile-web surface, and
the read/write backend for the admin dashboard. It is the **authorization source of
truth** — no client role or claim is trusted.

## Domain boundaries

The API is organised as NestJS modules under `src/modules/<name>/` on shared
infrastructure in `src/common/`. The validation-phase domain modules and what each
owns:

- **auth** — phone-OTP flow, session/JWT issuance and refresh. No password path.
- **users** — the person behind a phone number; acquisition snapshot; age
  confirmation.
- **venues** — venue records (team-managed), geo coordinates, membership of the
  Zone 4 launch area.
- **venue-nights** — the `VenueNight` aggregate: live status and its timestamp,
  night headline / DJ, per-night rollups. Everything night-scoped hangs here.
- **going** — "J'y vais" marks and the per-VenueNight aggregate count.
- **feed** — the polymorphic `FeedItem` store and the server-side ranking endpoint.
- **follows** — client ↔ venue subscriptions.
- **promotions** — venue offers/events, usually attached to a VenueNight.
- **media** — S3-backed photo upload; venue photos vs user photos (curation queue).
- **attribution** — raw acquisition/landing events with structured source params.
- **analytics-proxy** — server-side PostHog forwarding with PII minimisation.
- **notifications** — FCM; the two scheduled notifications and opt-in venue
  broadcasts.

The build status of these modules is tracked in
`../docs/validation-mvp/VYBA_CODEBASE_AUDIT.md`.

## Invariants

1. **Authorization is server-side, always.** Guards and role checks run on every
   protected route regardless of what the client sends.
2. **Night-scoped state belongs to a `VenueNight`.** Do not add resettable fields
   like `is_live` / `going_count` / `live_since` to `Venue`. Query "tonight" by
   `VenueNight (venue, date = today)`. (ADR-0001)
3. **`assisted` is a domain-enforced fact.** Any code path that creates venue
   content records the real creator and whether a team member assisted. It must
   not be possible for an admin/assist workflow to produce venue content without
   this being recorded. Owner-created ⇒ `assisted = false`.
4. **The "J'y vais" count is trustworthy.** One mark per user / venue / night,
   editable until midnight, aggregate resets/decays daily, owners cannot
   contribute to their own count, repeat-submission abuse is blocked.
5. **Identity is a phone number.** OTP verification is the only way in; the phone
   number links the same person across app and web. (ADR-0003)
6. **Attribution is kept raw.** Store landing/acquisition events as they arrive;
   do not collapse a user's history to a single source field. `acquisition_zone`
   and `active_zone` are distinct.
7. **Never log OTPs, tokens, or PII** — see `../docs/security.md`.

## Deliberately not in the validation backend

Real table/VIP booking, reviews, boosts, SaaS billing, realtime going counts
(Socket.IO is present in infra but unused — poll-on-view only). See the spec for
the full deferred list.

## Template origin

Bootstrapped from a generic NestJS monolith template. Some scaffolding still
carries the template's original domain (e.g. role constants) and is being replaced
— treat `../CONTEXT.md` and the ADRs as authoritative over leftover template code.
