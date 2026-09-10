# ADR-0003: Phone-OTP as the sole identity primitive

## Status

Accepted (2026-09-10)

## Context

Vyba needs user accounts for following venues, personalised notifications, and —
critically — a trustworthy "J'y vais" signal that can't be trivially gamed. The
template shipped with email + password auth and social-login buttons.

In the launch market (Abidjan), phone numbers are close to universal and are the
identifier people actually use; email is secondary. Social login adds third-party
SDKs, privacy surfaces, and platform dependencies for little gain here. Meanwhile,
the QR / mobile-web surface needs the same identity as the app so a person who
marks "J'y vais" on the web is the same account when they later install the app.

The "J'y vais" metric also can't tolerate anonymous marks — they'd make the number
meaningless.

## Decision

**Phone number + OTP is the only identity primitive.** No email/password, no social
login.

- The phone number is the canonical user identity, shared across the app and the
  web surface.
- Marking "J'y vais" on the web requires phone + OTP verification (no anonymous
  path). The verified web session then persists.
- Installing the app and verifying the same number resolves to the same account,
  carrying history.
- Venue owner accounts are provisioned by the Vyba team (phone bound to venue),
  not self-serve.

The internal admin dashboard is exempt — it may keep email/password for the team,
since it is not an end-user surface.

## Rationale

- Matches how the market actually identifies people.
- One identity across both surfaces with no account-linking logic.
- Fewer SDKs, fewer privacy surfaces, fewer platform dependencies.
- Anonymous "J'y vais" is structurally impossible, protecting the core metric.

## Consequences

- OTP delivery becomes a launch-critical dependency: an Africa-focused SMS provider
  with proven Côte d'Ivoire routes, a registered "Vyba" sender ID, a WhatsApp
  fallback, and a pre-launch deliverability test across the three networks. Poor
  OTP delivery would silently cap signups and be misread as weak demand.
- The mobile social-login buttons, email login/register, and forgot-password flows
  are removed.
- The backend `auth` module is reworked around request-OTP / verify-OTP; the
  `User` record becomes phone-first.
- SMS cost per verification is a real budget line.
