# 01: Backend domain reset

**What to build:** The NestJS backend stops carrying the starter template's
family/zone domain and speaks Vyba's. The shared role vocabulary becomes
`ADMIN` / `VENUE_OWNER` / `CLIENT`, the `User` record becomes phone-first (a
unique required E.164 `phone`, no `password`, optional name, plus nullable
`ageConfirmedAt` and acquisition-snapshot placeholders), and the template's
email/password + family/zone scaffolding is removed. The app compiles, boots, and
the existing test suite is green. No new endpoints, no OTP logic yet.

**Blocked by:** None (can start immediately).

**Specs:** `../specs/01-backend-phone-otp-auth.md` (the entity + role parts only).
**Seam:** backend build + existing test suite; adjust/replace template tests.

**Status:** ready-for-agent

- [ ] Role enum/constants are `ADMIN`, `VENUE_OWNER`, `CLIENT`; `CLIENT` is the default; role metadata copy no longer mentions families/zones.
- [ ] `User` entity: `phone` unique + required (E.164), `password` removed, name fields optional, `role`, `isActive`, `ageConfirmedAt` (nullable), acquisition-snapshot fields (nullable).
- [ ] `UsersService` exposes `findByPhone` and a create-from-phone path; no `bcrypt`, no `findByEmail`.
- [ ] Template email/password auth service methods and the family/zone entities/DTOs are removed (auth is left with only what compiles; full OTP flow is ticket 04).
- [ ] Guards, decorators (`@Roles`, `@GetUser`, `@Public`) and middleware reference the new role vocabulary.
- [ ] `yarn build` passes; `yarn test` passes (template-specific tests updated or removed); `yarn lint` clean.
- [ ] A migration exists (or dev auto-sync verified) for the new schema; no leftover `email`/`password` columns in the `users` model.
