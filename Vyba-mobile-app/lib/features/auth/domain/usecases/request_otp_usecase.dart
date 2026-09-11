import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Requests (or resends) an OTP code for a phone number.
class RequestOtpUseCase extends UseCase<void, RequestOtpParams> {
  /// Creates a [RequestOtpUseCase].
  const RequestOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(RequestOtpParams params) {
    return _repository.requestOtp(phoneNumber: params.phoneNumber);
  }
}

/// Parameters for [RequestOtpUseCase].
class RequestOtpParams {
  /// Creates [RequestOtpParams].
  const RequestOtpParams({required this.phoneNumber});

  /// E.164 phone number.
  final String phoneNumber;
}
