# 02: Mobile cleanup & scope

**What to build:** The Flutter app is stripped to the validation scope. Dead
template features are deleted, the venue model is corrected to the launch market,
the app becomes French-only, and out-of-scope-but-keep features are unrouted. No
new features, no backend wiring. `flutter analyze` is clean and the remaining test
suite is green.

**Blocked by:** None (can start immediately) — **but see the co-ordination note
below.**

**Specs:** `../specs/09-mobile-cleanup-and-scope.md`; verdicts in
`../VYBA_CODEBASE_AUDIT.md` §2.
**Seam:** `flutter analyze` clean + `flutter test` green; `venues` model tests
adjusted.

> ⚠️ **Co-ordination:** a parallel Lagos→Abidjan rebrand has uncommitted edits in
> many of the files this ticket deletes or rewrites (`search_page.dart`,
> `book_table_page.dart`, `explore_page.dart`, `app_colors.dart`, mock
> datasources, onboarding). **Do not start until that rebrand work is committed**,
> or this ticket destroys uncommitted work. Work from a clean `Vyba-mobile-app/`
> tree.

**Status:** ready-for-agent

- [ ] `features/notes` + `core/sync` (Drift offline-sync queue) deleted; `Vyba-mobile-app/docs/offline_sync.md` removed or marked superseded.
- [ ] `features/search`, `features/bookings`, `features/owner_bookings` deleted (folders, routes, route names, providers, mock datasources, tests).
- [ ] `features/auth` reduced to the phone-OTP path: `social_login_buttons`, email `login_usecase`/`register_usecase` + pages, `forgot_password_*` removed; phone/OTP use cases, OTP page, auth notifier/state/providers kept.
- [ ] `features/reviews`, `features/owner_analytics`, `features/venue_management` left in the tree but unrouted and unreferenced.
- [ ] `Venue` entity: `openingHours`, `hasVipPass` removed; price label uses FCFA not `₦`; `VenueType` = club/bar/lounge/maquis only; `venue_menu` model/page/usecase/route removed. Mock datasource updated to the corrected model.
- [ ] Client shell "Bookings" tab and its route removed.
- [ ] Settings screen trimmed to the validation set; "Un problème ?" entry opens WhatsApp via a configured number.
- [ ] French-only: `app_en.arb` dropped from generation (or stubbed), supported locales = French, any locale switcher removed.
- [ ] `core/router`: deleted routes and `_publicPaths` entries removed; splash/onboarding/role-selection/login/otp kept.
- [ ] `flutter analyze` reports zero issues; `flutter test` green; grep of `lib/` for `bookings`/`notes`/`sync`/`₦`/`rooftop`/`beachClub` is empty.
- [ ] The parallel Lagos→Abidjan rebrand is not touched, reverted, staged, or cleaned.
