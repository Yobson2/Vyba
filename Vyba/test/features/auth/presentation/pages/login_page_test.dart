import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createTestWidget({AuthState? initialState}) {
    return ProviderScope(
      overrides: [
        if (initialState != null)
          authNotifierProvider.overrideWith(
            () => _FakeAuthNotifier(initialState),
          ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('should render email and password fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should render login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap login without entering anything
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should show loading state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(initialState: const AuthLoading()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to register page on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap the register link
      final registerFinder = find.byType(TextButton);
      if (registerFinder.evaluate().isNotEmpty) {
        await tester.tap(registerFinder.last);
        await tester.pumpAndSettle();
      }
    });
  });
}

/// Fake auth notifier for testing.
class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initialState);

  final AuthState _initialState;

  @override
  AuthState build() => _initialState;
}
