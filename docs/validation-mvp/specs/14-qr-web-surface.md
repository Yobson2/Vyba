# Spec: qr-web-surface

> Ready-for-agent spec. Vyba validation MVP critical path (unit 14) — the acquisition hook. Depends on backend 01–05, 07.
> Source of truth: `VYBA_VALIDATION_MVP_SPEC.md` §6.2, §11.3, §20.3; `docs/adr/0004-separate-lightweight-web-surface.md`; `CONTEXT.md`.
> Draft — not yet published to GitHub Issues.

## Problem Statement

The primary way clients discover Vyba during validation is a QR code on a table tent
in an onboarded venue. The person scanning it is in a bar, at night, on a congested
connection, with no relationship to Vyba. If they don't hit meaningful content in
about a second, the moment is gone — and the Flutter web build cannot meet that
budget. Forcing an app-store install before showing any value is equally fatal.

There is no web surface today.

## Solution

A new, separate, lightweight web app (React/Next or equivalent) served fast, hitting
the same Vyba API with the same phone-number identity. It is read-mostly: a venue
page (identity, tonight's status, going count, tonight's promo/event, minimal info),
a phone-OTP "J'y vais", and a read-only Zone 4 feed. It captures attribution
parameters, and promotes the native app only after the user has experienced value.

## User Stories

1. As someone who just scanned a venue's QR code, I want the venue's page to appear almost instantly, so that I don't give up.
2. As a visitor, I want to see what's happening at this venue tonight — is it live, what's on, how many are going — so that I can decide.
3. As a visitor, I want to see tonight's promo or event for this venue, so that I know if there's a reason to go.
4. As a visitor, I want minimal venue info (type, address, a way to open Maps), so that I can get there.
5. As a visitor, I want to tap "J'y vais", so that I can signal I'm coming.
6. As a visitor, I want to verify my phone with a code to make "J'y vais" count, so that the number stays real — done in one quick step.
7. As a visitor, I want my verified session to persist, so that a second action doesn't ask for another code.
8. As a visitor, I want a link to "voir ce qui se passe à Zone 4", so that I can see beyond this one venue.
9. As a visitor browsing the Zone 4 feed on the web, I want to read it, so that I get a sense of the scene — even though I can't do much else here.
10. As a visitor who's seen the value, I want an unobtrusive prompt to get the app (for notifications, following, a personalised feed), so that I can go deeper if I want — but not before.
11. As a visitor on a weak connection, I want the page to stay usable (small payload, no heavy map), so that it works where I am.
12. As the Vyba team, I want the venue's QR to carry that venue's id so the visit and any signup are attributed to it, so that we know which venues drive users.
13. As the Vyba team, I want a promoter's link to carry their id, so that promoter channels are measured.
14. As a platform operator, I want `qr_landing_opened` and the signup event (with source) emitted, so that the QR funnel is measurable.
15. As a security reviewer, I want the web surface to use the same auth and never handle more PII than the app, so that it isn't a weaker door.
16. As a developer, I want the web surface decoupled from the Flutter app but sharing the API contract, so that it can be optimised for speed independently.

## Implementation Decisions

**Project**

- A new top-level project (e.g. `Vyba-web/`) — React/Next (or a comparably light
  stack). Not part of the Flutter app; not the Flutter web build. Its own build,
  deploy, and test setup.
- Consumes the same backend API and the phone-OTP flow (backend unit 01). Shares the
  identity: a phone verified here is the same account in the app.

**Routes / surfaces**

- `/{venueSlugOrId}` (the QR target) — the venue page. Server-rendered or otherwise
  first-paint-optimised.
- `/zone4` — the read-only Zone 4 feed (list of `FeedItem`s, server order, no
  actions beyond opening a venue).
- A minimal verify flow (phone → code) triggered by "J'y vais" when there's no
  session.

**Public read API**

- The venue page and `/zone4` are served from **unauthenticated, read-only,
  rate-limited public endpoints** (defined in backend units 02 and 03): explicitly
  public, PII-free data only; no "who's going" identities, no follower data, no
  owner data; no mutations; abuse-monitored; must not weaken existing
  authenticated/private authorization.
- The flow: **QR scan → public venue read → public Zone 4 feed → "J'y vais" →
  phone → OTP → authenticated session → Going.** No anonymous device
  identity/token is introduced unless a later concrete requirement demands one —
  the pre-auth surface is genuinely anonymous and read-only.

**Venue page content**

- Identity (name, type), tonight's `VenueNight` state (live + `liveSince`, headline,
  "X personnes y vont ce soir"), tonight's promo/event, address + "Ouvrir dans
  Google Maps" (link, not an embedded interactive map), "J'y vais", link to `/zone4`.
- If no `VenueNight` today: "rien d'annoncé ce soir" + the profile.

**"J'y vais" on web**

- If session present → call the backend `going` mark endpoint directly.
- If not → phone entry → code → verify (backend unit 01, includes the 18+
  confirmation on first verify) → session persisted (secure, httpOnly cookie or
  equivalent) → complete the mark.
- Party size optional; identity private by default.

**Attribution**

- Read `src`, `venue`, `pid`, `campaign` from the query string on first load;
  persist (cookie/localStorage) for the session; send with the landing event
  (`qr_landing_opened`) and with signup. Forward via the backend attribution
  endpoint (unit 07). `acquisition_venue_id` should default to the QR's venue when
  `src=qr`.

**App promotion**

- After a completed "J'y vais" (or on a second visit), show an unobtrusive "Télécharge
  l'app pour suivre tes lieux et recevoir les infos" with a Play Store link. Never a
  blocking interstitial, never before the first value.

**Performance budget (launch gate — MVP spec §20.3)**

- Meaningful venue content visible **< 1s** where realistically achievable, **2.5s
  hard ceiling** on a throttled mobile profile on a low-end device.
- Small JS payload; system fonts or a single subsetted font; images via the backend
  renditions at display size; no map SDK; minimal third-party script.
- Measured as part of pre-cohort QA.

**Design**

- One of the four design-investment surfaces (MVP spec §17). Dark-first, brand
  tokens, no-line rule — but the speed budget wins any tie.

**Language**

- French only.

## Testing Decisions

**Good test:** route/page integration against a **mocked API (MSW)** — render the
venue page for a mocked venue-with-VenueNight and assert the tonight block, the going
count, and that "J'y vais" with an existing session calls the mark endpoint; render
without a session and assert the phone→code→verify→mark sequence; assert `src`/`venue`
query params are captured and sent with the landing and signup calls; assert the app
prompt does not render before a completed action.

**Seam:** the web app's **route/page integration layer with MSW**. Establish MSW as
the single test seam for this project. No component-internal tests, no e2e browser
suite for validation (a couple of Playwright smoke checks for the critical path are
optional).

**Modules under test:** the venue page and the verify/"J'y vais" flow.

**Prior art:** none in this repo (new project) — this unit sets the convention.

**Representative cases:** QR load `?src=qr&venue=V1` → venue page renders fast,
`qr_landing_opened` sent with `venue=V1`; venue with live `VenueNight` → "live" +
count shown; no `VenueNight` → "rien d'annoncé ce soir"; "J'y vais" no session →
phone/code flow → mark completes → session cookie set; second "J'y vais" same
session → no code prompt; signup carries `src=qr`, `venue=V1`; app-download prompt
appears only after the first completed "J'y vais".

## Out of Scope

- A full web product (following, personalised feed, notifications) — that's the app.
- Any anonymous device identity/token — the pre-auth surface is anonymous *and*
  read-only; the first authenticated identity is the phone number at "J'y vais".
- Interactive maps on web.
- iOS App Store links beyond a generic "get the app" (Android-first).
- The QR code generation and print kit (ops / MVP spec §22.1).
- Server infrastructure / hosting choices (ops) — the app just needs to be deployable
  and fast.
- SEO / marketing pages / a landing site.

## Further Notes

- ADR-0004 is the rationale for a separate surface and the performance budget.
- The performance target is a **launch gate**, not an aspiration (MVP spec §20.3) —
  build and measure against it from the start.
- Shared identity with the app is the point: verifying the same phone number in the
  app later must resolve to the same account (backend unit 01 guarantees this).
