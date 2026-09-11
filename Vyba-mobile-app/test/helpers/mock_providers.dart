import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/core/storage/secure_storage.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_templates/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_templates/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/cancel_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/get_mine_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/update_going_usecase.dart';
import 'package:flutter_templates/features/promotions/domain/usecases/create_promo_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/get_my_venue_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/get_tonight_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_headline_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_live_usecase.dart';
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

/// Mock implementation of [RequestOtpUseCase].
class MockRequestOtpUseCase extends Mock implements RequestOtpUseCase {}

/// Mock implementation of [VerifyOtpUseCase].
class MockVerifyOtpUseCase extends Mock implements VerifyOtpUseCase {}

/// Mock implementation of [RestoreSessionUseCase].
class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

/// Mock implementation of [LogoutUseCase].
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

/// Mock implementation of [GetCachedUserUseCase].
class MockGetCachedUserUseCase extends Mock implements GetCachedUserUseCase {}

// -- Venue night mocks --

/// Mock implementation of [GetMyVenueUseCase].
class MockGetMyVenueUseCase extends Mock implements GetMyVenueUseCase {}

/// Mock implementation of [GetTonightUseCase].
class MockGetTonightUseCase extends Mock implements GetTonightUseCase {}

/// Mock implementation of [SetLiveUseCase].
class MockSetLiveUseCase extends Mock implements SetLiveUseCase {}

/// Mock implementation of [SetHeadlineUseCase].
class MockSetHeadlineUseCase extends Mock implements SetHeadlineUseCase {}

// -- Feed mocks --

/// Mock implementation of [GetFeedUseCase].
class MockGetFeedUseCase extends Mock implements GetFeedUseCase {}

// -- Going mocks --

/// Mock implementation of [GetMineUseCase].
class MockGetMineUseCase extends Mock implements GetMineUseCase {}

/// Mock implementation of [MarkGoingUseCase].
class MockMarkGoingUseCase extends Mock implements MarkGoingUseCase {}

/// Mock implementation of [UpdateGoingUseCase].
class MockUpdateGoingUseCase extends Mock implements UpdateGoingUseCase {}

/// Mock implementation of [CancelGoingUseCase].
class MockCancelGoingUseCase extends Mock implements CancelGoingUseCase {}

// -- Promotions mocks --

/// Mock implementation of [CreatePromoUseCase].
class MockCreatePromoUseCase extends Mock implements CreatePromoUseCase {}
