/// String utility extensions.
extension StringX on String {
  /// Capitalizes the first letter.
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Capitalizes every word.
  String get titleCase => split(' ').map((word) => word.capitalized).join(' ');

  /// Whether this string is a valid email.
  bool get isEmail => RegExp(
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)+$',
      ).hasMatch(this);

  /// Whether this string is a valid phone number (must contain digits).
  bool get isPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-()]+'), '');
    return RegExp(r'^\+?\d{7,15}$').hasMatch(cleaned);
  }

  /// Returns the initials from a full name (e.g. "John Doe" → "JD").
  String get initials {
    final trimmed = trim();
    if (trimmed.isEmpty) return '';
    final words =
        trimmed.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  /// Truncates the string to [maxLength] with an ellipsis.
  String truncate(int maxLength) {
    assert(maxLength > 0, 'maxLength must be positive');
    if (maxLength <= 0) return '';
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Removes all whitespace from the string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Returns `null` if the string is empty, otherwise returns itself.
  String? get nullIfEmpty => isEmpty ? null : this;
}

/// Nullable string extensions.
extension NullableStringX on String? {
  /// Whether this is null or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns the string or a [fallback] if null/empty.
  String orDefault([String fallback = '']) => isNullOrEmpty ? fallback : this!;
}
