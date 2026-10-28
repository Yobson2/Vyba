# API overview

The Vyba REST API is served by `Vyba-backend/` (NestJS 11). This page is a
**map** of the API surface by module. For request and response schemas, guards
and roles, the source of truth is the generated Swagger UI:

```
http://localhost:3000/api/docs
```

Routes are under `/api/*`, except the health check. Requests go through Helmet,
CORS (`CORS_ORIGINS`) and a global `ValidationPipe`. See
[`backend.md`](backend.md) for conventions.

## Authentication

| Audience | Flow | Endpoints |
|---|---|---|
| People going out and venue owners | Phone + one-time code, then JWT access + refresh | `POST /api/auth/request-code` → `POST /api/auth/verify-code` → `POST /api/auth/refresh` |
| Vyba team (dashboard) | Email + password, then JWT carrying an admin role | `POST /api/auth/admin/login` |

Send the access token as `Authorization: Bearer <token>`. The backend
re-validates identity and role on every request, so client-side roles are only
UX hints. A few read endpoints are public for the QR web surface (for example
`GET /api/feed/public` and `GET /api/venues/:id/public`). Swagger marks which
ones require auth.

## Endpoints by module

### Health
| Method | Path |
|---|---|
| GET | `/health` |

### Auth (`auth`)
| Method | Path | Purpose |
|---|---|---|
| POST | `/api/auth/request-code` | Send a one-time code to a phone number |
| POST | `/api/auth/verify-code` | Verify the code, issue tokens |
| POST | `/api/auth/refresh` | Rotate the access token |
| POST | `/api/auth/admin/login` | Dashboard sign-in |
| GET · POST | `/api/auth/admin` | List / create admin accounts |
| PATCH | `/api/auth/admin/password` | Change own admin password |
| PATCH | `/api/auth/admin/:id` | Update an admin account |
| POST | `/api/auth/admin/:id/reset-password` | Reset another admin's password |

### Feed (`feed`)
| Method | Path | Purpose |
|---|---|---|
| GET | `/api/feed` | Personalised "Ce soir" feed (ranked server-side) |
| GET | `/api/feed/public` | Public feed for the QR web surface |
| GET | `/api/feed/admin` | Moderation view |
| POST | `/api/feed/venue/:venueId/promo` | Venue posts a promo |
| POST | `/api/feed/venue/:venueId/promo/assist` | Team posts on a venue's behalf (recorded as *assisted*) |
| POST · PATCH | `/api/feed/editorial` · `/api/feed/editorial/:id` | Team editorial content |
| PATCH | `/api/feed/:id/publish` · `/hide` · `/unhide` | Publication / moderation |
| DELETE | `/api/feed/:id` | Remove an item |

### Going: "J'y vais" (`going`)
| Method | Path | Purpose |
|---|---|---|
| POST | `/api/going` | Say "J'y vais" for tonight (with party size) |
| PATCH · DELETE | `/api/going/venue/:venueId` | Edit / cancel tonight's intent |
| GET | `/api/going/venue/:venueId/mine` | Caller's intent for tonight |
| GET | `/api/going/venue/:venueId/owner-summary` | Owner view: count and party sizes |

### Venues (`venues`) and venue nights (`venue-nights`)
| Method | Path | Purpose |
|---|---|---|
| GET · POST | `/api/venues` | List / create venues (team-managed) |
| GET · PATCH · DELETE | `/api/venues/:id` | Read / update / delete |
| POST · DELETE | `/api/venues/:id/owner` | Bind / unbind the owner account |
| GET | `/api/discover/venues` | Discovery: text search and nearby |
| GET | `/api/owner/venue` | The signed-in owner's venue |
| POST | `/api/venues/:id/live` | "On est live ce soir" |
| GET · PATCH | `/api/venues/:id/tonight` | Tonight's VenueNight (headline, DJ, …) |
| GET | `/api/venues/:id/detail` | Venue + tonight, app view |
| GET | `/api/venues/:id/public` | Venue + tonight, QR web view |

### Follows (`follows`)
| Method | Path |
|---|---|
| POST · DELETE | `/api/follows/venue/:venueId` |
| GET | `/api/follows/venue/:venueId/mine` |
| GET | `/api/follows/mine` |

### Reservations (`reservations`): opt-in per venue
| Method | Path | Purpose |
|---|---|---|
| POST | `/api/reservations` | Same-night table request |
| DELETE | `/api/reservations/venue/:venueId` | Cancel own request |
| GET | `/api/reservations/venue/:venueId/mine` · `/availability` · `/owner` | Caller / capacity / owner views |
| PATCH | `/api/reservations/:id/respond` | Owner confirms or rejects (capacity-gated) |

### Media (`media`)
| Method | Path | Purpose |
|---|---|---|
| POST | `/api/media/venue-night-photo` · `/api/media/owner/venue-photo` | Upload photos (S3) |
| GET | `/api/media/venue/:venueId/night-photos` | Tonight's photos |
| GET | `/api/media/admin` | Curation queue |
| PATCH | `/api/media/:id/promote` · `/hide` | Curation |
| DELETE | `/api/media/:id` · `/api/media/admin/:id` | Removal |

### Notifications (`notifications`)
| Method | Path | Purpose |
|---|---|---|
| POST · DELETE | `/api/notifications/device-token` | Register / remove an FCM token |
| GET · PATCH | `/api/notifications/preferences` | Notification preferences |
| GET | `/api/notifications/venue-opt-ins/mine` | Venues the caller accepts broadcasts from |
| GET · POST · DELETE | `/api/notifications/venue/:venueId/opt-in` | Broadcast opt-in |
| POST | `/api/notifications/venue/:venueId/broadcast` | Owner broadcast to opted-in people |
| POST | `/api/notifications/jobs/weekend-digest/run` · `/going-reminder/run` | Trigger the scheduled jobs manually |

### Metrics (`metrics`): validation dashboard
| Method | Path |
|---|---|
| GET | `/api/metrics/zone4-wau` |
| GET | `/api/metrics/retention` |
| GET | `/api/metrics/organic-posting` |
| GET | `/api/metrics/going-per-night` |
| GET | `/api/metrics/active-venues` |
| GET | `/api/metrics/content-activity` |
| GET | `/api/metrics/monitor/tonight` |
| GET | `/api/metrics/venue/:venueId/organic-vs-assisted` |

### Attribution and analytics
| Method | Path | Purpose |
|---|---|---|
| POST | `/api/attribution/landing` | Record an acquisition landing (QR, promoter link, …) |
| POST | `/api/analytics/track` | Product analytics event |

### Users (`users`)
| Method | Path |
|---|---|
| GET · POST | `/api/users` |
| GET · PATCH · DELETE | `/api/users/:id` |

## Real-time

A Socket.IO gateway exists (`src/common/websockets/events.gateway.ts`, with a
Redis bridge), but no client in this repository connects to it yet.

## Keeping this page current

This map was extracted from the `@Controller` / `@Get|Post|Patch|Delete`
decorators in `Vyba-backend/src/modules/**`. When you add or rename a route,
update the matching table, or rely on Swagger for anything finer-grained.
