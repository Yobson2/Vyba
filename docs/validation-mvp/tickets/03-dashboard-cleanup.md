# 03: Dashboard cleanup

**What to build:** The admin dashboard is reorganised around the validation
surfaces. Out-of-scope template features are unrouted, settings is trimmed, the
role vocabulary matches the backend, self-serve sign-up is removed, and the shared
`data-table` components are in place for units that follow. No new features. The
app builds and the existing test suite is green.

**Blocked by:** None (can start immediately) — **but see the co-ordination note
below.**

**Specs:** `../specs/15-dashboard-cleanup.md`; verdicts in
`../VYBA_CODEBASE_AUDIT.md` §3.
**Seam:** `pnpm build` + `pnpm lint` + `pnpm knip` clean; existing tests green.

> ⚠️ **Co-ordination:** the parallel Lagos→Abidjan rebrand has uncommitted edits in
> `sidebar-data.ts`, several `features/*/data/*.ts`, `index.css`, `index.html`,
> settings forms and more — files this ticket rewrites or removes. **Do not start
> until that rebrand work is committed.** Work from a clean
> `Vyba-dashboard-admin/` tree.

**Status:** ready-for-agent

- [ ] `features/tasks` + route and the `_authenticated/apps/` route deleted; `(auth)/sign-up` route + feature removed.
- [ ] `features/bookings`, `features/reviews`, `features/landing-page` + `_public/`, `audit-log/` route, and the `notifications` route unrouted and de-navigated (folders kept for post-validation).
- [ ] `features/settings` trimmed to `admins` + `appearance`; `platform`/`security`/`notifications`/`profile` settings pages and routes removed; `SETTINGS_NAV_ITEMS` updated.
- [ ] `features/users` reduced to a minimal read view (list, acquisition source, support lookup) — not full CRUD.
- [ ] Role type/strings replaced with `ADMIN`/`VENUE_OWNER`/`CLIENT` everywhere the dashboard references roles; aligned with backend ticket 01. Dashboard auth stays email+password.
- [ ] `sidebar-data.ts` rebuilt around: Provisioning, Content & curation, Monitoring & metrics, Settings — with placeholder pages where units 16–18 aren't built.
- [ ] The six shared `data-table-*` pieces exist under `components/ui/data-table/` and new/edited features import from there.
- [ ] `pnpm build` passes, `pnpm lint` clean, `pnpm knip` shows no new dead exports; existing tests green (removed-feature tests deleted); removed routes 404 via the errors feature.
- [ ] Grep of `src/` for the old role strings (`CHEF_ZONE`, `MEMBRE`) is empty.
- [ ] The parallel Lagos→Abidjan rebrand is not touched, reverted, staged, or cleaned.
