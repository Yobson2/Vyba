# Domain Docs

How the engineering skills should consume this repo's domain documentation when
exploring the codebase. This repo is **multi-context**: three deployables with
separate domains, stacks and conventions.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root — global product and domain knowledge (the
  glossary). It also acts as the map: it links to each sub-project's `CONTEXT.md`.
- The **sub-project `CONTEXT.md`** for the area you're touching:
  - `Vyba-backend/CONTEXT.md`
  - `Vyba-mobile-app/CONTEXT.md`
  - `Vyba-dashboard-admin/CONTEXT.md`
- **`docs/adr/`** — architectural decisions and their rationale. Read the ADRs that
  touch the area you're about to work in before changing anything in that area.
- **`CLAUDE.md`** — global navigation and non-negotiable rules (design, security).
- **`docs/`** — detailed mechanics per sub-project (`backend.md`, `mobile.md`,
  `dashboard.md`, `security.md`, `design-system.md`).
- **`docs/validation-mvp/`** — the current build target: the validation MVP spec
  and the codebase audit.

If a file doesn't exist, **proceed silently**. `/domain-modeling` creates CONTEXT
and ADR content lazily as terms and decisions get resolved.

## File structure

```
/
├── CLAUDE.md                        ← global instructions + navigation
├── CONTEXT.md                       ← global product/domain glossary + map
├── docs/
│   ├── adr/                         ← project-wide decisions + rationale
│   ├── agents/                      ← this file, issue-tracker.md
│   ├── validation-mvp/              ← current spec + audit
│   └── *.md                         ← detailed mechanics per sub-project
├── Vyba-backend/CONTEXT.md          ← backend domain boundaries + invariants
├── Vyba-mobile-app/CONTEXT.md       ← mobile domain boundaries + invariants
└── Vyba-dashboard-admin/CONTEXT.md  ← dashboard purpose + boundaries
```

Layering principle:

| Layer | Holds |
|---|---|
| `CLAUDE.md` | global instructions + navigation only |
| `CONTEXT.md` (root) | stable product/domain knowledge |
| sub-project `CONTEXT.md` | that sub-project's domain boundaries + invariants |
| `docs/` | detailed mechanics |
| `docs/adr/` | decisions + rationale |
| code | source of truth for implementation detail |

Don't duplicate detail across layers. Don't document file paths in CONTEXT files.

## Use the glossary's vocabulary

When your output names a domain concept (an issue title, a refactor proposal, a
hypothesis, a test name), use the term as defined in the root `CONTEXT.md`
glossary — e.g. **VenueNight**, **"J'y vais"**, **FeedItem**, **Follow**,
**Boost**. Don't drift to synonyms ("reservation" for "J'y vais", "post" where the
glossary says "FeedItem").

If the concept you need isn't in the glossary, that's a signal: either you're
inventing language the project doesn't use, or there's a real gap to note for
`/domain-modeling`.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than
silently overriding:

> _Contradicts ADR-0002 (soft "J'y vais" intent instead of reservations), but
> worth reopening because…_
