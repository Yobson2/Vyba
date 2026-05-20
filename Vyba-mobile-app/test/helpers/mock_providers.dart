import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_templates/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:mocktail/mocktail.dart';

// -- Core mocks --

/// Mock implementation of [NetworkInfo].
class MockNetworkInfo extends Mock implements NetworkInfo {}

/// Mock implementation of [LocalStorage].
class MockLocalStorage extends Mock implements LocalStorage {}

/// Mock implementation of [SecureStorage].
class MockSecureStorage extends Mock implements SecureStorage {}

// -- Auth mocks --

/// Mock implementation of [AuthRepository].
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock implementation of [AuthRemoteDataSource].
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

/// Mock implementation of [AuthLocalDataSource].
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

/// Mock implementation of [LoginUseCase].
class MockLoginUseCase extends Mock implements LoginUseCase {}

/// Mock implementation of [RegisterUseCase].
class MockRegisterUseCase extends Mock implements RegisterUseCase {}

/// Mock implementation of [ForgotPasswordUseCase].
class MockForgotPasswordUseCase extends Mock implements ForgotPasswordUseCase {}

/// Mock implementation of [VerifyOtpUseCase].
class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

/// Mock implementation of [LogoutUseCase].
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Mock implementation of [GetCachedUserUseCase].
class MockGetCachedUserUseCase extends Mock implements GetCachedUserUseCase {}
