import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Page object for interacting with authentication screens.
///
/// Usage:
/// ```dart
/// final auth = AuthRobot(tester);
/// await auth.enterEmail('test@example.com');
/// await auth.enterPassword('Password1!');
/// await auth.tapLogin();
/// auth.expectHomePage();
/// ```
class AuthRobot {
  /// Creates an [AuthRobot].
  const AuthRobot(this.tester);

  final WidgetTester tester;

  /// Enters text into the email field.
  Future<void> enterEmail(String email) async {
    final field = find.byType(TextFormField).first;
    await tester.enterText(field, email);
    await tester.pump();
  }

  /// Enters text into the password field.
  Future<void> enterPassword(String password) async {
    final field = find.byType(TextFormField).at(1);
    await tester.enterText(field, password);
    await tester.pump();
  }

  /// Taps the primary login button.
  Future<void> tapLogin() async {
    final button = find.widgetWithText(ElevatedButton, 'Login');
    // Fallback: try localized text or generic button
    if (button.evaluate().isEmpty) {
      final primaryButton = find.byType(ElevatedButton).first;
      await tester.tap(primaryButton);
    } else {
      await tester.tap(button);
    }
    await tester.pumpAndSettle();
  }

  /// Verifies the app navigated to the home page.
  void expectHomePage() {
    // After successful login, the home route should be active.
    // Adjust the finder based on your HomePage implementation.
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  }

  /// Verifies an error message is displayed.
  void expectError(String message) {
    expect(find.text(message), findsOneWidget);
  }

  /// Taps the "Register" navigation link.
  Future<void> tapRegister() async {
    final link = find.widgetWithText(TextButton, 'Register');
    if (link.evaluate().isNotEmpty) {
      await tester.tap(link);
      await tester.pumpAndSettle();
    }
  }

  /// Taps the "Forgot Password" link.
  Future<void> tapForgotPassword() async {
    final link = find.widgetWithText(TextButton, 'Forgot Password?');
    if (link.evaluate().isNotEmpty) {
      await tester.tap(link);
      await tester.pumpAndSettle();
    }
  }
}
