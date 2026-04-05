import 'package:flutter_templates/bootstrap.dart';
import 'package:flutter_templates/core/config/app_config.dart';

/// Default entry point — uses app config environment.

void main() async {
  await bootstrap(const AppConfig());
}
