import 'dart:convert';

/// Reads the `exp` claim (seconds since epoch) out of a JWT without
/// verifying its signature — client-side use only, to decide whether to
/// refresh before making a request. The server remains the source of truth.
DateTime? jwtExpiry(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;

  try {
    final normalized = base64Url.normalize(parts[1]);
    final payload = json.decode(utf8.decode(base64Url.decode(normalized)));
    if (payload is! Map<String, dynamic>) return null;
    final exp = payload['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
  } catch (_) {
    return null;
  }
}

/// Whether [token]'s `exp` claim has passed (or is within [leeway]), or the
/// token is unreadable. A malformed token is treated as expired.
bool isJwtExpired(String token,
    {Duration leeway = const Duration(seconds: 30)}) {
  final expiry = jwtExpiry(token);
  if (expiry == null) return true;
  return DateTime.now().toUtc().isAfter(expiry.subtract(leeway));
}
