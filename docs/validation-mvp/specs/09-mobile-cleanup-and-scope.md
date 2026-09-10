# Spec: mobile-cleanup-and-scope

> Ready-for-agent spec. Vyba validation MVP (unit 09). **Prerequisite** for mobile units 10–13.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §8; `VYBA_CODEBASE_AUDIT.md` §2; `Vyba-mobile-app/CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The Flutter app was adapted from a template and carries a large amount of
scaffolding the validation build does not use: an offline-sync engine and a `notes`
demo feature, a standalone search feature, a reservation-shaped `bookings` flow,
email/password and social-login screens, and venue fields from a different market
(Naira pricing, venue types like "rooftop" / "beach club"). Working on the real
features (units 10–13) while this is in place means constantly navigating dead code
and risking building on the wrong pattern.

## Solution

A pure removal-and-scope pass, no new features. Delete the code that the audit marks
`DELETE`, unroute the code marked `DEFER`, strip auth down to the phone-OTP path,
correct the venue model to the launch market, and make the app French-only. The app
still builds, `flutter analyze` is clean, and the remaining test suite is green.

## User Stories

1. As a developer, I want the offline-sync engine and the `notes` feature removed, so that I'm not maintaining a queue the product doesn't use.
2. As a developer, I want the `search` feature removed, so that discovery is a filter on the venue list, not a search box.
3. As a developer, I want the `bookings` and `owner_bookings` features removed, so that nothing competes with "J'y vais".
4. As a developer, I want the social-login buttons and email/password + forgot-password screens removed from `auth`, so that only the phone-OTP path remains.
5. As a developer, I want `reviews`, `owner_analytics` and `venue_management` left in the tree but unrouted and unreferenced, so that they're available post-validation without being in the build's surface.
6. As a developer, I want the venue model corrected — price shown in FCFA not Naira, venue types limited to club / bar / lounge / maquis, and the `venue_menu`, `openingHours`, `hasVipPass` fields removed — so that the model matches the launch market and the spec.
7. As a developer, I want the client shell's tabs updated to remove the "Bookings" tab, so that navigation reflects the validation scope.
8. As a user, I want the app in French only, so that the experience is coherent for the launch market.
9. As a developer, I want `app_en.arb` dropped from the build (or reduced to a stub) and the localization delegate French-only, so that there's no English translation to keep in sync.
10. As a user, I want a "Un problème ?" entry in settings that opens WhatsApp, so that I can reach support.
11. As a developer, I want the settings screen trimmed to what validation needs (notification prefs placeholder, "Un problème ?", legal links placeholder, sign out, delete account placeholder), so that it's not a template settings page.
12. As a developer, I want `flutter analyze` to pass clean after the removals, so that the codebase stays lint-green.
13. As a developer, I want the remaining test suite to pass after the removals (tests for deleted features removed, tests for kept features untouched), so that regressions are visible.
14. As a developer, I want the mock datasources and providers for deleted features removed too, so that no dead wiring remains in the Riverpod graph.
15. As a developer, I want routes, route names and imports for deleted features removed, so that the router compiles cleanly.

## Implementation Decisions

**Delete entirely** (feature folder + tests + routes + route names + providers +
mock datasources + any `core` support unique to them):

- `features/notes` and `core/sync` (the Drift offline-sync queue). Also remove
  `Vyba-mobile-app/docs/offline_sync.md` or mark it superseded.
- `features/search`.
- `features/bookings`, `features/owner_bookings`.
- From `features/auth`: `social_login_buttons`, the email `login_usecase` /
  `register_usecase` and their pages/wiring, `forgot_password_*`. Keep
  `login_with_phone_usecase`, `verify_otp_usecase`, `get_cached_user_usecase`,
  `logout_usecase`, the OTP page, the auth notifier/state/providers.

**Keep but unroute** (leave folder in place; remove from router, route names,
sidebar/shell, and any provider that's only used by routed code):

- `features/reviews`, `features/owner_analytics`, `features/venue_management`.

**Modify**

- `features/venues`:
  - `Venue` entity: remove `openingHours`, `hasVipPass`; `priceLevelLabel` uses
    `FCFA` (or a neutral price indicator), not `₦`.
  - `VenueType` enum: `club`, `bar`, `lounge`, `maquis` only (remove `restaurant`,
    `rooftop`, `beachClub`). Update any switch/exhaustive usage.
  - Remove `venue_menu` model, page, usecase, and menu route.
  - Do **not** wire the real API here — that's unit 11. Mock datasource stays,
    adjusted to the corrected model.
- `features/home`: client shell tabs → Feed / Explore / (a "J'y vais" or activity
  tab — final tab set is unit 11/12's call; here just remove the Bookings tab and
  its route). Owner shell untouched here (unit 13).
- Settings page: trim to the validation set; add "Un problème ?" → opens WhatsApp
  via a URL launcher with a configured number.
- Localization: French-only. Remove `app_en.arb` from the generation config (or
  stub it), set supported locales to French, drop the locale switcher if present.
- `core/router`: remove deleted routes and `_publicPaths` entries; keep
  splash/onboarding/role-selection/login/otp.

**Do not**

- Touch the parallel Lagos→Abidjan rebrand work (out of scope, per project owner).
- Rename the `flutter_templates` package (deferred, cosmetic).
- Add any new feature, screen, or API call.
- Modify `docs/mobile.md` (update when the corresponding sections are actually
  contradicted by merged code; note the offline-sync section is now stale).

## Testing Decisions

**What a good test looks like here:** this unit is defined by *absence*. The
meaningful checks are: the app compiles, `flutter analyze` is clean, and every test
that should still pass does. Tests belonging to deleted features are deleted with
them; tests for kept features (`auth` phone/OTP usecases, `venues`) must still pass
unchanged.

**Seam:** the build and the existing test suite. `flutter analyze` clean +
`flutter test` green. No new tests are required beyond adjusting `venues` tests for
the corrected model and a small test that the settings "Un problème ?" action
constructs the right WhatsApp URL.

**Modules under test:** none added; `venues` model tests adjusted.

**Prior art:** existing `test/features/**` structure; `docs/mobile.md` lint config
(`very_good_analysis` + `custom_lint` + `riverpod_lint`).

**Representative checks:** `flutter analyze` reports zero issues; `flutter test`
passes; grep for `bookings` / `notes` / `sync` / `₦` / `rooftop` / `beachClub` in
`lib/` returns nothing; the router file has no unresolved imports; the app launches
to splash → onboarding/login.

## Out of Scope

- Wiring any real backend API (units 10–13).
- The final client tab set and its screens (units 11–12).
- Owner shell rework (unit 13).
- Notification preference screens (unit 12) — only a placeholder entry here.
- Legal/consent screens (privacy work) — placeholder link only.
- The Lagos→Abidjan rebrand.

## Further Notes

- This unit is a prerequisite: units 10–13 assume the cleaned tree.
- `VYBA_CODEBASE_AUDIT.md` §2.2 is the per-feature verdict table this implements.
- After merge, `docs/mobile.md`'s "Offline sync" section and any shell-tab
  description are stale — flagged for update when units 11–13 land.
