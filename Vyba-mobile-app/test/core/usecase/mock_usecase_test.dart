import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestUseCase extends UseCase<String, _TestParams> {
  const _TestUseCase({required this.result});

  final Either<Failure, String> result;

  @override
  Future<Either<Failure, String>> call(_TestParams params) async => result;
}

class _TestParams {
  const _TestParams(this.value);
  final String value;
}

void main() {
  group('UseCase', () {
    test('should return Right on success', () async {
      const useCase = _TestUseCase(result: Right('success'));

      final result = await useCase(const _TestParams('test'));

      expect(result, const Right<Failure, String>('success'));
    });

    test('should return Left on failure', () async {
      const failure = ServerFailure(message: 'Server error');
      const useCase = _TestUseCase(result: Left(failure));

      final result = await useCase(const _TestParams('test'));

      expect(result, const Left<Failure, String>(failure));
    });
  });

  group('NoParams', () {
    test('should support equality', () {
      expect(NoParams(), equals(NoParams()));
    });
  });
}
