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
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/get_my_opt_ins_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/is_opted_in_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/opt_in_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/opt_out_usecase.dart';
import 'package:flutter_templates/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/follow_venue_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/get_my_followed_venues_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/is_following_usecase.dart';
import 'package:flutter_templates/features/follow/domain/usecases/unfollow_venue_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/cancel_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/get_mine_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/update_going_usecase.dart';
import 'package:flutter_templates/features/media/domain/usecases/get_venue_night_photos_usecase.dart';
import 'package:flutter_templates/features/media/domain/usecases/upload_venue_night_photo_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/deregister_device_token_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/register_device_token_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/set_notification_preferences_usecase.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/usecases/send_broadcast_usecase.dart';
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

// -- Follow mocks --

/// Mock implementation of [IsFollowingUseCase].
class MockIsFollowingUseCase extends Mock implements IsFollowingUseCase {}

/// Mock implementation of [FollowVenueUseCase].
class MockFollowVenueUseCase extends Mock implements FollowVenueUseCase {}

/// Mock implementation of [UnfollowVenueUseCase].
class MockUnfollowVenueUseCase extends Mock implements UnfollowVenueUseCase {}

/// Mock implementation of [GetMyFollowedVenuesUseCase].
class MockGetMyFollowedVenuesUseCase extends Mock
    implements GetMyFollowedVenuesUseCase {}

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

// -- Media mocks --

/// Mock implementation of [UploadVenueNightPhotoUseCase].
class MockUploadVenueNightPhotoUseCase extends Mock
    implements UploadVenueNightPhotoUseCase {}

/// Mock implementation of [GetVenueNightPhotosUseCase].
class MockGetVenueNightPhotosUseCase extends Mock
    implements GetVenueNightPhotosUseCase {}

// -- Notification preferences mocks --

/// Mock implementation of [GetNotificationPreferencesUseCase].
class MockGetNotificationPreferencesUseCase extends Mock
    implements GetNotificationPreferencesUseCase {}

/// Mock implementation of [SetNotificationPreferencesUseCase].
class MockSetNotificationPreferencesUseCase extends Mock
    implements SetNotificationPreferencesUseCase {}

/// Mock implementation of [RegisterDeviceTokenUseCase].
class MockRegisterDeviceTokenUseCase extends Mock
    implements RegisterDeviceTokenUseCase {}

/// Mock implementation of [DeregisterDeviceTokenUseCase].
class MockDeregisterDeviceTokenUseCase extends Mock
    implements DeregisterDeviceTokenUseCase {}

// -- Broadcast opt-in mocks --

/// Mock implementation of [IsOptedInUseCase].
class MockIsOptedInUseCase extends Mock implements IsOptedInUseCase {}

/// Mock implementation of [OptInUseCase].
class MockOptInUseCase extends Mock implements OptInUseCase {}

/// Mock implementation of [OptOutUseCase].
class MockOptOutUseCase extends Mock implements OptOutUseCase {}

/// Mock implementation of [GetMyOptInsUseCase].
class MockGetMyOptInsUseCase extends Mock implements GetMyOptInsUseCase {}

// -- Owner broadcast mocks --

/// Mock implementation of [SendBroadcastUseCase].
class MockSendBroadcastUseCase extends Mock implements SendBroadcastUseCase {}
