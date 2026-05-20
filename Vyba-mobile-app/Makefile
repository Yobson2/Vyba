.PHONY: help get gen watch test analyze format l10n clean run icons splash integration

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

get: ## Install dependencies
	flutter pub get

gen: ## Run code generation (freezed, json_serializable, riverpod)
	dart run build_runner build --delete-conflicting-outputs

watch: ## Watch mode for code generation
	dart run build_runner watch --delete-conflicting-outputs

test: ## Run all unit and widget tests
	flutter test

integration: ## Run integration tests
	flutter test integration_test

analyze: ## Run static analysis
	flutter analyze

format: ## Format all Dart files
	dart format .

l10n: ## Generate localization files
	flutter gen-l10n

clean: ## Clean build artifacts
	flutter clean
	flutter pub get

run: ## Run the app in debug mode
	flutter run

icons: ## Generate app icons (requires flutter_launcher_icons)
	dart run flutter_launcher_icons

splash: ## Generate native splash screen (requires flutter_native_splash)
	dart run flutter_native_splash:create
