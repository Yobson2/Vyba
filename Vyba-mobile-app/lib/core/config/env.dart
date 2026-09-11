// / Abstract environment configuration.
// /
// / Provides environment-specific values such as API base URL

abstract class Env {
  /// Creates an [Env].
  const Env();

  /// Display name of the environment.
  String get name;

  /// Base URL for the API.
  String get baseUrl;

  /// Whether to enable verbose logging.
  bool get enableLogging;

  /// Whether to enable the debug overlay banner.
  bool get showDebugBanner;

  /// WhatsApp number (international format, digits only) for the
  /// "Un problème ?" support entry in Settings.
  String get supportWhatsappNumber;
}
