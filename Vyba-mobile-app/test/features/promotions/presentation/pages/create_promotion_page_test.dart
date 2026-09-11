import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';
import 'package:flutter_templates/features/promotions/presentation/pages/create_promotion_page.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/create_promo_notifier.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/create_promo_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Pushed on top of a real base route (rather than as `home` directly) so
  // the page's `Navigator.pop()` on a successful publish has somewhere to
  // go back to, matching how it's actually reached from the owner home.
  Widget createTestWidget({
    CreatePromoState initialState = const CreatePromoState(),
    _FakeCreatePromoNotifier? notifier,
  }) {
    return ProviderScope(
      overrides: [
        createPromoNotifierProvider.overrideWith(
          () => notifier ?? _FakeCreatePromoNotifier(initialState),
        ),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const CreatePromotionPage(),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  // Pumps a fixed duration rather than `pumpAndSettle` — the "submitting"
  // state renders an indeterminate `CircularProgressIndicator`, whose
  // animation never settles and would hang `pumpAndSettle` forever.
  Future<void> openPage(WidgetTester tester) async {
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('CreatePromotionPage', () {
    testWidgets('renders the title and description fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openPage(tester);

      expect(find.text('Titre'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('publish is disabled until a title is entered',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openPage(tester);

      final button =
          tester.widget<AppGradientButton>(find.byType(AppGradientButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('publish calls submit() once a title is entered',
        (tester) async {
      final notifier = _FakeCreatePromoNotifier(const CreatePromoState());
      await tester.pumpWidget(createTestWidget(notifier: notifier));
      await openPage(tester);

      await tester.enterText(
        find.byType(TextField).first,
        'Happy hour -50%',
      );
      await tester.pump();

      final button =
          tester.widget<AppGradientButton>(find.byType(AppGradientButton));
      expect(button.onPressed, isNotNull);

      await tester.tap(find.byType(AppGradientButton));
      await tester.pumpAndSettle();

      expect(notifier.submitCalls, 1);
    });

    testWidgets('shows a loading indicator while submitting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          initialState: const CreatePromoState(submitting: true),
        ),
      );
      await openPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the error message from state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          initialState:
              const CreatePromoState(errorMessage: 'Erreur serveur'),
        ),
      );
      await openPage(tester);

      expect(find.text('Erreur serveur'), findsOneWidget);
    });
  });
}

class _FakeCreatePromoNotifier extends CreatePromoNotifier {
  _FakeCreatePromoNotifier(this._initialState);

  final CreatePromoState _initialState;
  int submitCalls = 0;

  @override
  CreatePromoState build() => _initialState;

  @override
  Future<bool> submit({
    required String title,
    required String description,
  }) async {
    submitCalls++;
    return true;
  }
}
