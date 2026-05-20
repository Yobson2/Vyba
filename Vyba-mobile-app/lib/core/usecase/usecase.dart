import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';

/// Base class for all use cases in the domain layer.
///
/// Each use case encapsulates a single piece of business logic
/// and returns an [Either] with a [Failure] on the left
/// or a success value [T] on the right.
///
/// ```dart
/// class GetUser extends UseCase<User, GetUserParams> {
///   @override
///   Future<Either<Failure, User>> call(GetUserParams params) async {
///     return repository.getUser(params.id);
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  /// Creates a [UseCase].
  const UseCase();

  /// Executes the use case with the given [params].
  Future<Either<Failure, T>> call(Params params);
}

/// Use when a use case does not require any parameters.
class NoParams {
  /// Creates a [NoParams] instance.
  const NoParams();
}
