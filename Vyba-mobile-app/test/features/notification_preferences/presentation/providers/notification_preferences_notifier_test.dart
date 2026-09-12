import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/set_notification_preferences_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_notifier.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_providers.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockGetNotificationPreferencesUseCase mockGetUseCase;
  late MockSetNotificationPreferencesUseCase mockSetUseCase;

  const bothOn = NotificationPreferences(
    weekendDigest: true,
    goingReminder: true,
  );

  setUp(() {
    mockGetUseCase = MockGetNotificationPreferencesUseCase();
    mockSetUseCase = MockSetNotificationPreferencesUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const SetNotificationPreferencesParams(weekendDigest: true),
    );
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        getNotificationPreferencesUseCaseProvider
            .overrideWithValue(mockGetUseCase),
        setNotificationPreferencesUseCaseProvider
            .overrideWithValue(mockSetUseCase),
      ],
    );
  }

  group('NotificationPreferencesNotifier', () {
    test('loads both toggles as on by default', () async {
      when(() => mockGetUseCase(any()))
          .thenAnswer((_) async => const Right(bothOn));

      final container = createContainer();
      container.listen(notificationPreferencesNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(notificationPreferencesNotifierProvider);
      expect(state, isA<NotificationPreferencesLoaded>());
      expect(
        (state as NotificationPreferencesLoaded).preferences,
        bothOn,
      );
    });

    test('setWeekendDigest(false) optimistically flips, then confirms',
        () async {
      when(() => mockGetUseCase(any()))
          .thenAnswer((_) async => const Right(bothOn));
      when(() => mockSetUseCase(any())).thenAnswer(
        (_) async => const Right(
          NotificationPreferences(weekendDigest: false, goingReminder: true),
        ),
      );

      final container = createContainer();
      container.listen(notificationPreferencesNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final future = container
          .read(notificationPreferencesNotifierProvider.notifier)
          .setWeekendDigest(false);
      // Optimistic: flips before the backend call resolves.
      final optimistic = container.read(notificationPreferencesNotifierProvider)
          as NotificationPreferencesLoaded;
      expect(optimistic.preferences.weekendDigest, false);
      await future;

      final confirmed = container.read(notificationPreferencesNotifierProvider)
          as NotificationPreferencesLoaded;
      expect(confirmed.preferences.weekendDigest, false);
      verify(
        () => mockSetUseCase(
          const SetNotificationPreferencesParams(weekendDigest: false),
        ),
      ).called(1);
    });

    test('setGoingReminder(false) rolls back on failure', () async {
      when(() => mockGetUseCase(any()))
          .thenAnswer((_) async => const Right(bothOn));
      when(() => mockSetUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      container.listen(notificationPreferencesNotifierProvider, (_, __) {});
      await pumpEventQueue();

      await container
          .read(notificationPreferencesNotifierProvider.notifier)
          .setGoingReminder(false);

      final state = container.read(notificationPreferencesNotifierProvider)
          as NotificationPreferencesLoaded;
      expect(state.preferences.goingReminder, true);
    });
  });
}
