import 'package:dio/dio.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/features/notification_preferences/data/models/notification_preferences_model.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';

abstract class NotificationPreferencesRemoteDataSource {
  Future<NotificationPreferences> getPreferences();

  Future<NotificationPreferences> setPreferences({
    bool? weekendDigest,
    bool? goingReminder,
  });

  Future<void> registerDeviceToken(String token);

  Future<void> deregisterDeviceToken(String token);
}

class NotificationPreferencesRemoteDataSourceImpl
    implements NotificationPreferencesRemoteDataSource {
  const NotificationPreferencesRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<NotificationPreferences> getPreferences() async {
    try {
      final response = await _dio
          .get<Map<String, dynamic>>(ApiEndpoints.notificationsPreferences);
      return NotificationPreferencesModel.fromJson(response.data!);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<NotificationPreferences> setPreferences({
    bool? weekendDigest,
    bool? goingReminder,
  }) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        ApiEndpoints.notificationsPreferences,
        data: {
          if (weekendDigest != null) 'weekendDigest': weekendDigest,
          if (goingReminder != null) 'goingReminder': goingReminder,
        },
      );
      return NotificationPreferencesModel.fromJson(response.data!);
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> registerDeviceToken(String token) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.notificationsDeviceToken,
        data: {'token': token},
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  @override
  Future<void> deregisterDeviceToken(String token) async {
    try {
      await _dio.delete<void>(
        ApiEndpoints.notificationsDeviceToken,
        data: {'token': token},
      );
    } on DioException catch (e) {
      _throwMapped(e);
    }
  }

  Never _throwMapped(DioException e) {
    final wrapped = e.error;
    if (wrapped is Exception) throw wrapped;
    throw ServerException(message: e.message ?? 'Erreur réseau');
  }
}
