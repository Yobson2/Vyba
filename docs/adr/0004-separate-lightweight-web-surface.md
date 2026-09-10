# ADR-0004: A separate lightweight web surface, not Flutter web

## Status

Accepted (2026-09-10)

## Context

The primary client acquisition channel for validation is a QR code on a table tent
in each onboarded venue. The person scanning it is standing in a bar, at night, on
a congested mobile connection, with no prior relationship to Vyba. They need to hit
meaningful content — this venue, tonight's activity, the going count, "J'y vais" —
in about a second, or the moment is lost.

Three ways to serve that page were considered:

1. The **Flutter web build** of the existing app — no extra codebase, but a
   multi-megabyte bundle and multi-second first paint on a poor connection.
2. A **purpose-built lightweight web app** (React/Next or similar) hitting the same
   API.
3. **Server-rendered HTML** from the backend, minimally hydrated.

Forcing an app-store install before showing any value is also rejected — that's a
30–60% drop-off and minutes of waiting at exactly the wrong moment.

## Decision

Build a **separate, purpose-built lightweight web surface** (option 2, with option
3 acceptable), distinct from the Flutter app. It:

- Uses the same Vyba API and the same phone-number identity.
- Is **read-mostly**: venue page → "J'y vais" → link into Zone 4 discovery.
- Targets meaningful content visible in **under 1 second** where realistically
  achievable, with a **2.5 second hard ceiling** on the critical path.
- Promotes the native app install only **after** the user has experienced value.
- Has no interactive map (static representation + "open in Maps" link).

The Flutter app remains the power surface (personalised feed, following,
notifications, map, persistence).

## Rationale

- The acquisition funnel's highest-intent moment is the scan; its performance
  budget can't be met by Flutter web.
- Keeping the web surface small and independent lets it be optimised for speed
  without dragging in the app's weight.
- Shared API + shared identity mean no data or auth divergence despite two
  codebases.

## Consequences

- A second frontend codebase to build and maintain (adds a React developer to the
  team plan).
- API contracts must be designed to serve both a rich app and a minimal web page.
- The web surface needs its own test seam (mocked API), its own deploy, and its
  own performance QA on low-end devices as a launch gate.
- Attribution parameters (`?src=qr&venue=…`, promoter links) are handled first at
  the web surface and must survive into the app on install.
