# Vyba Validation MVP — Buildable Unit Specs

One ready-for-agent spec per buildable unit. Derived from
`../VYBA_VALIDATION_MVP_SPEC.md` and `../VYBA_CODEBASE_AUDIT.md`, decomposed by
implementation grain (one clear seam per spec, independently actionable).

**Status: drafts.** Not yet published to GitHub Issues — awaiting validation.
On publish, each becomes one issue labelled `ready-for-agent`.

## Units

| # | Spec | Area | Seam | Depends on |
|---|------|------|------|------------|
| 01 | backend-phone-otp-auth | Backend | HTTP e2e (supertest) | — |
| 02 | venue-night-model | Backend | HTTP e2e | 01 |
| 03 | feed | Backend | HTTP e2e | 01, 02 |
| 04 | going | Backend | HTTP e2e | 01, 02, 03 |
| 05 | follows | Backend | HTTP e2e | 01, 02 |
| 06 | media-and-photo-curation | Backend | HTTP e2e (fake storage) | 01, 02, 03 |
| 07 | attribution-and-analytics | Backend | HTTP e2e (fake PostHog) | 01, 02, 03, 04 |
| 08 | notifications | Backend | HTTP e2e + job fns (fake FCM, clock) | 01, 02, 04, 05 |
| 09 | mobile-cleanup-and-scope | Mobile | build + existing suite | — |
| 10 | mobile-auth-and-app-shell | Mobile | notifier↔usecase + OTP widget | 09, 01 |
| 11 | mobile-feed-and-venue-discovery | Mobile | notifier↔usecase + widget | 09, 10, 02–05 |
| 12 | mobile-going-follow-and-notification-prefs | Mobile | notifier↔usecase | 09, 10, 11, 04, 05, 08 |
| 13 | mobile-owner-shell | Mobile | notifier↔usecase + Accueil widget | 09, 10, 02, 03, 04, 05, 08 |
| 14 | qr-web-surface | Web (new project) | route/page + MSW | 01–05, 07 |
| 15 | dashboard-cleanup | Dashboard | build + existing suite | — |
| 16 | dashboard-provisioning | Dashboard | RTL + MSW | 15, 01, 02, 06 |
| 17 | dashboard-content-and-curation | Dashboard | RTL + MSW | 15, 16, 03, 06 |
| 18 | dashboard-monitoring-and-metrics | Dashboard | RTL + MSW | 15, 02, 03, 04, 07 |

## Critical path (a demoable core loop)

```
01 ──▶ 02 ──▶ 03 ──▶ 04
              │       │
              ▼       ▼
      05 ────────────────▶ 11 ──▶ 12        (mobile consumer loop)
                    │
09 ──▶ 10 ──────────┘
                    │
                    └─────▶ 14              (QR web acquisition)

15 ──▶ 16                                   (get venues + owners into the system)
```

**Gate-critical but not loop-critical:** 07 (validation must be measurable), 13 +
17 (the "organic posting" gate), 18 (the weekly review instrument).

**Enhancing:** 06, 08 (and their client sides in 11–13).

## Consolidations from the design pass

- **`promotions`** — not a separate unit. A promo is a `FeedItem` of `type=promo`;
  creation, provenance and expiry live in unit 03 (backend) and units 13/17 (create
  UIs).
- **Mobile notifications client** — dissolved: FCM token + deep links → unit 10;
  preference screens + reminder opt-in → unit 12; "Un problème?"→WhatsApp → unit 09.
- **Dashboard** — editorial + assist + photo curation → unit 17; VenueNight monitor
  + validation metrics → unit 18.

## Open questions flagged inside specs (resolve at review)

- 04: public going count = number of marks, not sum of party sizes (assumed).
- 07: multi-touch attribution snapshot = first-touch (assumed).
- 12: user night-photo upload entry point — unit 12 vs unit 11.
- 16: coordinate entry — plain lat/lng inputs acceptable vs a map picker.

## Resolved

- **QR pre-auth read** (specs 02, 03, 14): a separate unauthenticated, read-only,
  rate-limited **public read API** serves the QR venue page and the public Zone 4
  feed — public/PII-free fields only, no mutations, abuse-monitored, does not
  weaken authenticated authorization. Flow: QR scan → public venue read → public
  Zone 4 feed → "J'y vais" → phone → OTP → authenticated session → Going. No
  anonymous device token.

## Build order

The vertical tracer-bullet build order lives in `../tickets/` (each ticket cites
the spec(s) it draws its contract from). The specs here are the module reference;
the tickets are the demoable slices.

## Not specs (operational — see the MVP spec)

Hosting/region (§14.2), SMS vendor + sender ID + 3-network test (§14.1, §20.2),
PostHog project + EU hosting (§11.1), the Zone 4 polygon value (§23.2), FR
Privacy Policy + ToS + ARTCI filing (§16), QA devices (§20.1), the venue
onboarding kit (§22.1), the editorial calendar (§22.2).
