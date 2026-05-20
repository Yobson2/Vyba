/// Domain entity representing authentication tokens.
class Tokens {
  /// Creates a [Tokens].
  const Tokens({
    required this.accessToken,
    required this.refreshToken,
  });

  /// JWT access token.
  final String accessToken;

  /// JWT refresh token.
  final String refreshToken;
}
