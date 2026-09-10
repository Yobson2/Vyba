# ADR-0002: Soft "J'y vais" intent instead of reservations

## Status

Accepted (2026-09-10)

## Context

The original product framing included "book a table in advance". But the launch
venues are bars and *maquis* in Zone 4 / Marcory, which are overwhelmingly
walk-in: no host stand, no reservation book, tables claimed on arrival. Asking
those venues to adopt a reservation workflow — confirming, holding tables, managing
a book — is asking them to change how they operate, on day one, for an unproven
app. That is the fastest way to lose venue supply.

At the same time, the product needs a signal that a user has *decided to go* — it's
the "Décide → J'y vais" step of the core loop and one of the five things the
validation phase must measure.

## Decision

The primary intent mechanism is **"J'y vais"**: a low-friction "I'm coming tonight
(with N people)" signal. It is **not** a guaranteed reservation.

- Shown publicly as an aggregate count ("23 personnes y vont ce soir"). Identity is
  private by default, opt-in to reveal.
- One mark per user / venue / night, editable until midnight, aggregate resets
  daily.
- The venue owner sees the count and rough party sizes but is **not required to
  approve or respond**. No table is held.
- Owners cannot contribute to their own count; repeat-submission abuse is blocked
  server-side.

Real table / VIP booking is **deferred to post-validation**, and only for the
subset of higher-end lounges where that behaviour already exists.

## Rationale

- Zero operational change required from a maquis to participate.
- Still produces the decision signal the loop and the metrics need.
- The aggregate count doubles as social proof and as a feed-ranking input —
  genuine intent is a stronger relevance signal than a promo post.
- Keeping it non-transactional keeps commission-based monetisation off the table,
  which is deliberate (revenue should follow audience, not precede it).

## Consequences

- There is no booking confirmation, no table inventory, no no-show handling in the
  validation build. The mobile `bookings` feature and the dashboard booking
  management are cut.
- The count's integrity is a core concern: its trustworthiness is an invariant
  (see `Vyba-backend/CONTEXT.md`), not a nice-to-have.
- "J'y vais" requires connectivity — a stale offline intent is worse than none, so
  it fails visibly rather than queuing.
- If validation shows users won't take even this low-friction action, that is a
  real finding about the loop, not a UX detail to iterate around.
