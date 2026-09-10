# Vyba Mobile App — Domain Context

Domain boundaries and invariants for the Flutter app. For commands, layer
contracts, the Riverpod DI graph, routing, networking and lint, read
`../docs/mobile.md`. For product vocabulary, read `../CONTEXT.md`. Code is the
source of truth for implementation detail.

## Role

The power surface for both actors, as a single app with two role shells:

- **Client shell** — Feed (core), Explore (map + venue list), "J'y vais" (going
  activity), Profile.
- **Owner shell** — a deliberately minimal set: tonight's going count, one-tap
  "on est live ce soir", create a promotion, basic activity. Everything heavier
  (analytics, venue profile editing, booking management) is the Vyba team's job in
  the dashboard during validation.

The role only selects a shell. The backend enforces what each account may actually
do.

## Architecture invariants

1. **Clean Architecture per feature** under `lib/features/<name>/` with
   `domain` / `data` / `presentation` layers. Use cases return
   `Either<Failure, T>`; presentation state is a Freezed sealed union. Don't
   bypass a layer.
2. **The feed is server-ranked.** The app renders the order the API returns; it
   does not re-sort or re-rank feed items locally.
3. **"J'y vais" requires connectivity.** It is a live intent signal — if offline,
   it fails visibly. It is never queued. (Contrast: the feed and venue list may be
   shown from a last-known read cache.)
4. **No offline sync engine.** The validation build keeps only a read cache for
   the feed and venue list. The template's offline-sync queue and the `notes`
   demo feature are being removed — see the audit.
5. **Phone-OTP only.** No social login buttons, no email/password screens in the
   shipped flow. (ADR-0003)
6. **French only**, with an Abidjan register for social copy. The English ARB is
   being dropped from the build.
7. Design tokens from `lib/core/theme/*` only; dark-first; no-line rule. The four
   consumer surfaces (feed, venue page, "J'y vais" flow, and the sibling QR web
   page) get real design investment; the owner shell stays functional.

## Feature boundaries (validation scope)

In: `auth` (phone-OTP), `feed`, `venues` (discovery + detail), a `going` feature
for "J'y vais", `follows` (venue following), `promotions` (owner create),
`notifications`, minimal owner shell, splash/onboarding/role-selection.

Deferred/removed: real booking, reviews, standalone search, owner analytics, owner
booking management, venue profile editing in-app, the offline-sync engine, the
`notes` feature. The per-feature verdicts are in
`../docs/validation-mvp/VYBA_CODEBASE_AUDIT.md`.

## Template origin

Bootstrapped from a Flutter Clean Architecture template; the Dart package is still
named `flutter_templates` (imports are `package:flutter_templates/...`). Some
features and the offline-sync machinery are template scaffolding, not Vyba
product — `../CONTEXT.md` and the ADRs are authoritative over leftover template
code.
