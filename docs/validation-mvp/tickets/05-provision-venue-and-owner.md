# 05: Provision a venue + owner; owner reaches the owner shell

**What to build:** A Vyba team member opens the dashboard, creates a venue (name,
description, address, coordinates, type, price level), sees whether it falls inside
the Zone 4 polygon, and creates a venue-owner account by phone number bound to that
venue. That owner then signs into the app and lands in the owner shell (even if the
shell is still mostly empty).

**Blocked by:** 03 (dashboard cleanup), 04 (phone-OTP sign-in).

**Specs:** `../specs/02-venue-night-model.md` (Venue + polygon + owner-endpoints), `../specs/16-dashboard-provisioning.md`, `../specs/01-backend-phone-otp-auth.md` (owner provisioning).
**Seam:** backend HTTP e2e; dashboard RTL + MSW page integration.

**Status:** ready-for-agent

- [ ] Backend: `Venue` entity (durable fields only — no night state), admin CRUD, `pointInLaunchArea` against a single configured Zone 4 / Marcory polygon, `inLaunchArea` derived from coordinates.
- [ ] Backend: owner-provisioning endpoint — `ADMIN` creates a `VENUE_OWNER` user by phone + name and binds it to a venue; unbind/re-bind supported; no password.
- [ ] Backend: only `ADMIN` can create/edit venues or owner accounts.
- [ ] Dashboard: venues table (shared `data-table`), create/edit dialog with the venue fields, an `inLaunchArea` badge from the API response.
- [ ] Dashboard: "create / bind owner" flow from a venue row (phone + name); the bound owner shows on the row; unbind works.
- [ ] Dashboard: venue status control (onboarding / active / paused).
- [ ] Mobile: an owner account signs in (ticket 04 flow) and routes to the owner shell.
- [ ] Demo: create a venue in the dashboard, create + bind an owner, sign that owner into the app → owner shell; a venue with out-of-area coordinates shows "hors zone".
