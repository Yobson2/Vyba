// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/auth_robot.dart';

/// Integration tests for the application.
///
/// Run with: `flutter test integration_test` or `make integration`
///
/// These tests run on a real device or emulator and verify
/// end-to-end user flows.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth flow', () {
    testWidgets('user can see login page after splash', (tester) async {
      // Uncomment and adapt once your app is wired up:
      //
      // await tester.pumpWidget(
      //   ProviderScope(
      //     overrides: await createTestOverrides(),
      //     child: const App(),
      //   ),
      // );
      // await tester.pumpAndSettle();
      //
      // final auth = AuthRobot(tester);
      //
      // await auth.enterEmail('test@example.com');
      // await auth.enterPassword('Password1!');
      // await auth.tapLogin();
      // auth.expectHomePage();
    });
  });
}
