import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/core/widgets/inputs/app_phone_field.dart';
import 'package:flutter_templates/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_templates/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget createTestWidget({AuthState? initialState}) {
    return ProviderScope(
      overrides: [
        if (initialState != null)
          authNotifierProvider.overrideWith(
            () => _FakeAuthNotifier(initialState),
          ),
      ],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (_, __) => const LoginPage()),
            GoRoute(
              path: '/otp-verification',
              builder: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('should render the phone field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppPhoneField), findsOneWidget);
    });

    testWidgets('should render a single continue button, no social buttons',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppGradientButton), findsOneWidget);
      expect(find.textContaining('Google'), findsNothing);
      expect(find.textContaining('Apple'), findsNothing);
    });

    testWidgets('should show loading state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(initialState: const AuthLoading()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
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
