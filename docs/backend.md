# Backend API — `Vyba-backend/`

NestJS 11 monolith serving the REST API for both frontends. Bootstrapped from a
NestJS monolithic template; the full template reference (infra rationale, Docker
services, env matrix) is [`Vyba-backend/README.md`](../Vyba-backend/README.md).

**Stack**: NestJS 11 · TypeORM + PostgreSQL 16 · Redis (ioredis) · BullMQ ·
Socket.IO (Redis bridge) · JWT access + refresh · S3-compatible storage · Firebase
Admin (push) · Nodemailer + Handlebars · Swagger. Package manager: **yarn**.

## Commands

```bash
yarn install
docker compose up -d      # PostgreSQL + Redis + MinIO + Adminer
yarn start:dev            # hot-reload (Swagger at http://localhost:3000/api/docs)
yarn build
yarn start:prod
yarn lint
yarn format
yarn test | test:watch | test:cov | test:e2e

# Migrations (production; dev uses TypeORM auto-sync)
yarn migration:generate
yarn migration:run
yarn migration:revert
```

## Environment

Copy `.env.example` → `.env`. Groups: app (`NODE_ENV`, `PORT`, `CORS_ORIGINS`),
DB (`DB_*`), auth (`JWT_SECRET`, `JWT_REFRESH_SECRET`), Redis (`REDIS_*`), S3
(`S3_*`), mail (`MAIL_*`), `RUNNING_IN_DOCKER`. The config loader is Docker-aware
(`src/common/config/environment.loader.ts`).

## Structure

```
src/
├── main.ts             # bootstrap: Helmet, CORS, Swagger, global ValidationPipe
├── app.module.ts
├── common/             # shared infrastructure
│   ├── config/         database/ (TypeORM config, BaseEntity)  redis/  storage/  firebase/
│   ├── mail/  websockets/  queues/  middleware/ (JWT auth)  filters/ (global exception)
│   ├── guards/         auth.guard, roles.guard
│   ├── decorators/     @GetUser  @Roles  @Public
│   ├── dto/            pagination (PaginationQueryDto, PaginatedResponseDto)
│   ├── exceptions/     domain exceptions (base + per-domain)
│   └── constants/      error-codes, roles
└── modules/
    ├── auth/           register / login / refresh
    ├── users/          reference CRUD module
    └── health/
templates/              # Handlebars email templates
```

## Module conventions

Mirror `modules/users/`:

- **Controller** — `@ApiTags` / `@ApiOperation` / `@ApiResponse` / `@ApiBearerAuth`
  on every route; `@Public()` opts a route out of auth; `@UseGuards(RolesGuard)` +
  `@Roles(UserRole.ADMIN)` for privileged routes; list routes take
  `@Query() PaginationQueryDto`.
- **Service** — constructor-injected `@InjectRepository`, a `Logger` named after
  the class, returns entities or `PaginatedResponseDto`, throws typed domain
  exceptions (`<X>NotFoundError`, `<X>AlreadyExistsError`) from
  `common/exceptions/`. Passwords via `bcrypt.hash(value, 10)`.
- **DTOs** — `create-<x>.dto.ts` with `class-validator` decorators;
  `update-<x>.dto.ts` = `PartialType(CreateXDto)`.
- **Entity** — extends `BaseEntity` (`common/database/base.entity.ts`), soft
  delete via an `isActive` flag rather than row removal.
- Register `TypeOrmModule.forFeature([...])` in the module and import the module
  in `app.module.ts`.

## Security

The backend is the **authorization source of truth** — never trust a client's
`UserRole`. See [`security.md`](security.md) (S1, S4, S5, S6, S8, S20 document the
server-side expectations the frontends assume).
