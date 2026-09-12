import 'package:dio/dio.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
import 'package:flutter_templates/core/utils/logger.dart';

/// Raw landing capture (ticket 11 / spec 07) — `POST /api/attribution/landing`.
///
/// "Hold until signup, forward on verify" is handled by the persisted
/// client id itself ([LocalStorage.getOrCreateClientId]): it's stable
/// across app restarts and always sent with `verify-code`, so the backend
/// can match a landing recorded here to a signup much later without this
/// class holding anything in memory.
///
/// No caller wires this to a real entry point yet — this app has no
/// deep-link/app-links plugin installed, so there's nothing to intercept a
/// `?src=qr&venue=...` open with. Ready for ticket 16 (QR/web attribution)
/// to call from its deep-link handler.
class AttributionService {
  AttributionService(this._dio, this._clientId);

  final Dio _dio;
  final String Function() _clientId;

  Future<void> captureLanding({
    required String src,
    required String surface,
    String? venueId,
    String? promoterId,
    String? campaignId,
  }) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.attributionLanding,
        data: {
          'src': src,
          'surface': surface,
          'clientId': _clientId(),
          if (venueId != null) 'venueId': venueId,
          if (promoterId != null) 'promoterId': promoterId,
          if (campaignId != null) 'campaignId': campaignId,
        },
      );
    } catch (e) {
      // Attribution capture must never crash or block the app.
      AppLogger.debug('Landing capture failed: $src ($e)', tag: 'Attribution');
    }
  }
}
