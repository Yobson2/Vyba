# Contributing to Vyba

Thanks for helping build Vyba. This guide covers how work flows through the
repository. For running the apps locally, see [`docs/SETUP.md`](docs/SETUP.md).

## Before you start

1. Read [`CONTEXT.md`](CONTEXT.md) for the product vocabulary (VenueNight,
   "J'y vais", FeedItem, …) and the validation-phase scope rule: **anything that
   doesn't strengthen the core loop is out of scope** for now.
2. Skim the [ADRs](docs/adr/README.md). If your change contradicts one, write a
   new ADR rather than working around it.
3. Work inside one app at a time and follow its conventions. Don't cross-wire
   apps; they share only the API contract.

## Branches and pull requests

Changes are promoted **`dev` → `staging` → `main`** through pull requests.

```bash
git switch dev && git pull
git switch -c feat/<short-topic>      # or fix/…, docs/…, chore/…
# … commit …
git push -u origin feat/<short-topic>
gh pr create --base dev
```

- Keep PRs focused on one concern, and describe what changed and why.
- Never commit directly to `main`.
- Issues are tracked in GitHub Issues on `Yobson2/Vyba`
  ([conventions](docs/agents/issue-tracker.md)).

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/) with the app as
the scope:

```
feat(mobile): add going reminder opt-out
fix(backend): reject duplicate going for the same night
docs(api): document reservations endpoints
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`.
Scopes: `backend`, `mobile`, `dashboard`, `web`, `landing`, `brand`, `docs`.

## Required checks

Run the checks for every app you touched before opening a PR. CI is not active
yet, so these checks are the only gate.

| App | Command |
|---|---|
| Backend | `yarn lint && yarn test` (and `yarn test:e2e` for API changes) |
| Dashboard | `pnpm lint && pnpm test && pnpm build` |
| QR web | `npm run lint && npm test && npm run build` |
| Mobile | `make analyze && make test && dart format --set-exit-if-changed .` |
| Landing | `npm run lint && npm run typecheck && npm run build` |

Mobile: run `make gen` after changing any `@freezed`, `@JsonSerializable` or
`@riverpod` class, and commit the generated files.

Backend: schema changes need a migration (`yarn migration:generate`), because
production doesn't auto-sync.

## Non-negotiable rules

These are treated as blocking in review:

**Design** ([`docs/design-system.md`](docs/design-system.md))
- Dark-first, and never pure black `#000000`.
- No 1px borders, dividers or outlines. Use tonal surface shifts instead.
- Rounded corners only, minimum radius 8px, and project shadow tokens only.
- Brand colours are semantic. Electric Indigo `#B0A3FF` is for CTAs, Emerald
  `#69F6B8` for success and availability only, and Golden Hour `#FFB148` for
  promos and VIP only.

**Security** ([`docs/security.md`](docs/security.md))
- Never commit secrets or real `.env` files. Commit only `.env.example`.
- Never log tokens, passwords, OTPs or personal data.
- `USE_MOCK_AUTH` defaults to `false` and never ships enabled.
- The backend is the authority on identity and permissions; client roles are hints.

**Product**
- French only for user-facing copy in the validation build.
- Don't invent claims, metrics or testimonials in marketing surfaces.

## Documentation

Update docs in the same PR as the change:

| You changed… | Update |
|---|---|
| A domain concept | `CONTEXT.md` (and the relevant sub-project `CONTEXT.md`) |
| A significant decision | New ADR in `docs/adr/` + its index |
| API routes | `docs/API.md` (Swagger updates itself) |
| Setup, ports or env vars | `docs/SETUP.md` and the app's `.env.example` |
| Deployment | `docs/DEPLOYMENT.md` |
