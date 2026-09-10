# Vyba

Abidjan Pulse nightlife platform — discover venues, book tables, leave reviews, and manage promotions. Built with Flutter using Clean Architecture, Riverpod, GoRouter, Dio, and Freezed.

## Features

- **Clean Architecture** — Domain, Data, and Presentation layers per feature
- **Riverpod** — State management with code generation
- **GoRouter** — Declarative routing with auth guards and bottom navigation shell
- **Dio** — HTTP client with auth interceptor (token refresh), error interceptor, and logging
- **Freezed** — Immutable models, sealed state unions, JSON serialization
- **Functional error handling** — `Either<Failure, T>` via dartz
- **Theme system** — Dark-first design with custom Vyba design tokens
- **Phone + OTP auth** — Login with phone number and OTP verification
- **Role selection** — Client and venue owner roles with role-specific flows
- **Venue discovery** — Search, browse, and explore nightlife venues
- **Bookings** — Table reservations for clients and booking management for owners
- **Reviews & ratings** — User reviews for venues
- **Promotions** — Venue promotions and deals
- **Owner dashboard** — Analytics and venue management for owners
- **Favorites** — Save and manage favorite venues
- **Notifications** — In-app notification feed
- **Offline-first sync** — Drift (SQLite) with sync queue engine
- **Secure storage** — Encrypted token storage via FlutterSecureStorage
- **Onboarding** — First-launch onboarding with completion tracking
- **Responsive design** — ScreenUtil + responsive breakpoints
- **Analytics & crash reporting** — Abstract interfaces, plug in any provider

## Getting Started

```bash
# 1. Clone and enter the project
cd Vyba

# 2. Copy environment file
cp .env.example .env

# 3. Install dependencies
make get

# 4. Run code generation
make gen

# 5. Run the app
make run
```

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # Root MaterialApp.router
├── bootstrap.dart               # Initialization (env, storage, crash reporting)
├── core/
│   ├── config/                  # Environment configuration (Env, AppConfig)
│   ├── enums/                   # Shared enums (UserRole, etc.)
│   ├── error/                   # Exceptions (data) & Failures (domain)
│   ├── extensions/              # String, Context, DateTime, Num, Widget
│   ├── network/                 # Dio client, interceptors, API endpoints
│   ├── providers/               # Core Riverpod providers
│   ├── router/                  # GoRouter config, route names, guards
│   ├── services/                # Crash reporter, analytics (abstract)
│   ├── database/                # Drift (SQLite) database, tables, DAOs
│   ├── sync/                    # Sync engine, status, config, providers
│   ├── storage/                 # LocalStorage, SecureStorage wrappers
│   ├── theme/                   # Colors, typography, spacing, radius, shadows
│   ├── usecase/                 # Base UseCase<T, Params> class
│   ├── utils/                   # Logger, validators, pagination
│   └── widgets/                 # Reusable UI components
│       ├── buttons/             # Primary, Secondary, Ghost, Icon, Loading
│       ├── data_display/        # Avatar, Badge, Card, Chip, ListTile, NetworkImage
│       ├── feedback/            # Dialog, BottomSheet, Snackbar, Toast
│       ├── inputs/              # TextField, Password, OTP, Search, Dropdown, Checkbox
│       ├── layout/              # Scaffold, AppBar, BottomNav, Responsive
│       ├── loading/             # Shimmer, ShimmerList
│       └── states/              # Empty, Error, Offline banner
└── features/
    ├── auth/                    # Authentication (phone + OTP, email, register)
    ├── bookings/                # Table reservations
    ├── favorites/               # Saved venues
    ├── feed/                    # Activity feed
    ├── home/                    # Home shell with bottom navigation
    ├── notes/                   # Notes (offline-first reference)
    ├── notifications/           # Notification feed
    ├── onboarding/              # First-launch onboarding flow
    ├── owner_analytics/         # Venue owner analytics
    ├── owner_bookings/          # Venue owner booking management
    ├── owner_dashboard/         # Venue owner dashboard
    ├── promotions/              # Venue promotions and deals
    ├── reviews/                 # Venue reviews and ratings
    ├── role_selection/          # Client / Owner role selection
    ├── search/                  # Venue search and discovery
    ├── splash/                  # Splash screen with init checks
    └── venue_management/        # Venue CRUD for owners
```

## Available Commands

```bash
make help          # Show all available commands
make get           # Install dependencies
make gen           # Run code generation (freezed, riverpod, json)
make watch         # Watch mode for code generation
make test          # Run unit and widget tests
make integration   # Run integration tests
make analyze       # Run static analysis
make format        # Format all Dart files
make l10n          # Generate localization files
make clean         # Clean build artifacts and reinstall
make run           # Run app in debug mode
make icons         # Generate app icons
make splash        # Generate native splash screen
```

## Testing

```bash
# Run all tests
make test

# Run a specific test file
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Run integration tests
make integration
```

Tests use `mocktail` for mocking. Test helpers and mock providers are in `test/helpers/`.

## Environment Configuration

The app uses `flutter_dotenv` to load environment variables from a `.env` file.

| Variable | Description | Example |
|----------|-------------|---------|
| `ENV_NAME` | Environment name | `development` |
| `BASE_URL` | API base URL | `https://api-dev.example.com/v1` |
| `ENABLE_LOGGING` | Enable HTTP/debug logging | `true` |
| `SHOW_DEBUG_BANNER` | Show Flutter debug banner | `true` |
| `USE_MOCK_AUTH` | Use mock auth datasource | `true` |
| `USE_MOCK_NOTES` | Use mock notes datasource | `true` |

To switch environments, copy the appropriate env file:
```bash
cp .env.development .env   # Development
cp .env.staging .env       # Staging
cp .env.production .env    # Production
```

## Architecture Overview

```
Page → Notifier → UseCase → Repository → DataSource (Dio/Storage)
                                ↓
                    Either<Failure, T> flows back up
                                ↓
                    Notifier updates state (freezed sealed class)
                                ↓
                    GoRouter redirects based on auth state
```

**Key patterns:**
- **UseCase base class** — `abstract class UseCase<T, Params>` with `Future<Either<Failure, T>> call(Params)`
- **Repository pattern** — Checks connectivity, catches exceptions, maps to `Failure`
- **Offline-first pattern** — Write-local-first, enqueue sync, background push. See [docs/offline_sync.md](docs/offline_sync.md)
- **Auth interceptor** — `QueuedInterceptor` handles automatic token refresh on 401
- **Crash reporting & analytics** — Abstract interfaces in `core/services/`, override providers with real implementations
