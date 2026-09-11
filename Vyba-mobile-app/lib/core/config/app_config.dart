import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_templates/core/config/env.dart';

/// Development environment configuration.
class AppConfig extends Env {
  /// Creates a [AppConfig].
  const AppConfig();

  @override
  String get name => dotenv.get('ENV_NAME', fallback: 'development');

  @override
  String get baseUrl =>
      dotenv.get('BASE_URL', fallback: 'https://api-dev.example.com/v1');

  @override
  bool get enableLogging =>
      dotenv.get('ENABLE_LOGGING', fallback: 'true') == 'true';

  @override
  bool get showDebugBanner =>
      dotenv.get('SHOW_DEBUG_BANNER', fallback: 'true') == 'true';

  @override
  String get supportWhatsappNumber =>
      dotenv.get('SUPPORT_WHATSAPP_NUMBER', fallback: '2250000000000');
}
