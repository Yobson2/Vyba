# Vyba Validation MVP — Tickets

Vertical tracer-bullet slices. Each cuts a thin complete path through backend +
client(s) + tests and is demoable on its own. Numbered in dependency order
(blockers always lower-numbered).

- Module contracts: `../specs/`
- Design source: `../VYBA_VALIDATION_MVP_SPEC.md`, `../VYBA_CODEBASE_AUDIT.md`, `../../adr/`

**Status: drafts, not published to GitHub.** On publish → one issue per ticket,
`ready-for-agent` label, GitHub-native "blocked by" edges.

## Dependency edges

| Ticket | Blocked by |
|---|---|
| 01 backend-domain-reset | — |
| 02 mobile-cleanup-and-scope | — |
| 03 dashboard-cleanup | — |
| 04 phone-otp-signin | 01, 02 |
| 05 provision-venue-and-owner | 03, 04 |
| 06 owner-live-tonight | 05 |
| 07 zone4-feed-live-and-editorial | 06 |
| 08 client-jy-vais-and-count | 06 |
| 09 owner-promo-to-feed | 07 |
| 10 follow-venue-and-feed-lift | 07 |
| 11 attribution-and-analytics-core | 04, 07 |
| 12 qr-web-public-read | 06, 07 |
| 13 dashboard-content-composer | 09, 03 |
| 14 user-photo-and-curation | 07, 09, 03 |
| 15 notifications-digest-and-reminder | 04, 07, 08 |
| 16 qr-web-jy-vais-and-attribution | 04, 08, 12, 11 |
| 17 owner-broadcast-and-optin | 15, 08 |
| 18 validation-metrics-and-monitor | 11, 09, 08, 03 |

## Frontier at start

01, 02, 03 (parallel — disjoint sub-projects). Everything else waits.

## Integration point

`going_milestone` feed items + the feed ranking going-boost are wired by whichever
of **07 / 08** merges second (small add); verified in 18. Neither blocks the other.
