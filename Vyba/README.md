# Flutter Clean Architecture Template

Production-ready Flutter template with Clean Architecture, Riverpod, GoRouter, Dio, and Freezed. Ready for both small and large projects.

## Features

- **Clean Architecture** — Domain, Data, and Presentation layers per feature
- **Riverpod** — State management with code generation
- **GoRouter** — Declarative routing with auth guards and bottom navigation shell
- **Dio** — HTTP client with auth interceptor (token refresh), error interceptor, and logging
- **Freezed** — Immutable models, sealed state unions, JSON serialization
- **Functional error handling** — `Either<Failure, T>` via dartz
- **Theme system** — Light/dark mode with Material 3 design tokens
- **50+ reusable widgets** — Buttons, inputs, feedback, loading, states, layout
- **Localization** — ARB-based i18n (English + French)
- **Offline-first sync** — Drift (SQLite) with sync queue engine, write-local-first, background push ([docs](docs/offline_sync.md))
- **Offline support** — Connectivity monitoring with automatic offline banner
- **Secure storage** — Encrypted token storage via FlutterSecureStorage
- **Auth flow** — Login, register, forgot password, OTP verification, token refresh
- **Onboarding** — First-launch onboarding with completion tracking
- **Pagination** — Scroll-based pagination utility
- **Form validation** — Composable validators
- **Responsive design** — ScreenUtil + responsive breakpoints
- **Analytics & crash reporting** — Abstract interfaces, plug in any provider
- **CI/CD** — GitHub Actions workflow + Makefile

## Getting Started

```bash
# 1. Clone and enter the project
cd flutter_templates

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
    ├── auth/                    # Authentication (full Clean Architecture)
    │   ├── data/                # DataSources, Models, Repository impl
    │   ├── domain/              # Entities, Repository interface, UseCases
    │   └── presentation/        # Pages, Providers, Widgets
    ├── home/                    # Home shell with bottom navigation
    ├── notes/                   # Notes feature (offline-first reference implementation)
    ├── onboarding/              # First-launch onboarding flow
    └── splash/                  # Splash screen with init checks
```

## Adding a New Feature

1. Create the feature directory under `lib/features/your_feature/`

2. **Domain layer** — Define entities, repository interface, and use cases:
   ```
   domain/
   ├── entities/your_entity.dart
   ├── repositories/your_repository.dart
   └── usecases/your_usecase.dart
   ```

3. **Data layer** — Implement models, datasources, and repository:
   ```
   data/
   ├── models/your_model.dart          # @freezed with toEntity()
   ├── datasources/your_datasource.dart
   └── repositories/your_repository_impl.dart
   ```

4. **Presentation layer** — Create pages, state, and providers:
   ```
   presentation/
   ├── pages/your_page.dart
   ├── providers/your_provider.dart    # @riverpod
   └── widgets/your_widget.dart
   ```

5. Run code generation: `make gen`

6. Add routes in `core/router/app_router.dart` and route names in `route_names.dart`

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

**Test structure mirrors the source:**
```
test/
├── helpers/
│   ├── mock_providers.dart    # Shared mocks
│   └── test_helpers.dart      # Test utilities (createTestApp, etc.)
├── core/
│   └── usecase/               # Base UseCase tests
└── features/
    └── auth/
        ├── data/repositories/  # Repository tests
        ├── domain/usecases/    # UseCase tests
        └── presentation/
            ├── pages/          # Widget tests
            └── providers/      # Notifier tests
```

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
