import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  const tParams = LoginParams(
    email: 'test@example.com',
    password: 'password123',
  );

  group('LoginUseCase', () {
    test('should return User when login is successful', () async {
      // Arrange
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, const Right<Failure, User>(tUser));
      verify(() => mockRepository.login(
            email: tParams.email,
            password: tParams.password,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when login fails', () async {
      // Arrange
      const failure = ServerFailure(message: 'Invalid credentials');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, const Left<Failure, User>(failure));
      verify(() => mockRepository.login(
            email: tParams.email,
            password: tParams.password,
          )).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      // Arrange
      const failure = NetworkFailure(message: 'No internet connection');
      when(() => mockRepository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, isA<Left<Failure, User>>());
    });
  });
}
