import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_providers.dart';
import 'package:flutter_templates/features/follow/presentation/widgets/follow_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockIsFollowingUseCase mockIsFollowingUseCase;
  late MockFollowVenueUseCase mockFollowVenueUseCase;
  late MockUnfollowVenueUseCase mockUnfollowVenueUseCase;

  const venueId = 'venue-1';

  setUp(() {
    mockIsFollowingUseCase = MockIsFollowingUseCase();
    mockFollowVenueUseCase = MockFollowVenueUseCase();
    mockUnfollowVenueUseCase = MockUnfollowVenueUseCase();
  });

  setUpAll(() {
    registerFallbackValue(venueId);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        isFollowingUseCaseProvider.overrideWithValue(mockIsFollowingUseCase),
        followVenueUseCaseProvider.overrideWithValue(mockFollowVenueUseCase),
        unfollowVenueUseCaseProvider
            .overrideWithValue(mockUnfollowVenueUseCase),
      ],
      child: const MaterialApp(
        home: Scaffold(body: FollowButton(venueId: venueId)),
      ),
    );
  }

  group('FollowButton', () {
    testWidgets('shows "Suivre" when not following', (tester) async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(false));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Suivre'), findsOneWidget);
      expect(find.text('Suivi'), findsNothing);
    });

    testWidgets('shows "Suivi" when following', (tester) async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(true));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Suivi'), findsOneWidget);
      expect(find.text('Suivre'), findsNothing);
    });

    testWidgets('tapping "Suivre" calls the follow use case and flips to "Suivi"',
        (tester) async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(false));
      when(() => mockFollowVenueUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivre'));
      await tester.pumpAndSettle();

      expect(find.text('Suivi'), findsOneWidget);
      verify(() => mockFollowVenueUseCase(venueId)).called(1);
    });

    testWidgets('tapping "Suivi" calls the unfollow use case and flips to "Suivre"',
        (tester) async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(true));
      when(() => mockUnfollowVenueUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Suivi'));
      await tester.pumpAndSettle();

      expect(find.text('Suivre'), findsOneWidget);
      verify(() => mockUnfollowVenueUseCase(venueId)).called(1);
    });
  });
}
