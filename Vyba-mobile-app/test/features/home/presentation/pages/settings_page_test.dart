import 'package:flutter_templates/features/home/presentation/pages/settings_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildWhatsAppSupportUri', () {
    test('builds a wa.me deep link from the configured number', () {
      final uri = buildWhatsAppSupportUri('2250000000000');

      expect(uri.toString(), 'https://wa.me/2250000000000');
      expect(uri.scheme, 'https');
      expect(uri.host, 'wa.me');
      expect(uri.path, '/2250000000000');
    });
  });
}
