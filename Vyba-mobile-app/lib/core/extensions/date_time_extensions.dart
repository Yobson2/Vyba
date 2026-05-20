import 'package:intl/intl.dart';

/// DateTime utility extensions.
extension DateTimeX on DateTime {
  /// Whether this date is today (handles UTC timestamps correctly).
  bool get isToday {
    final local = toLocal();
    final now = DateTime.now();
    return local.year == now.year &&
        local.month == now.month &&
        local.day == now.day;
  }

  /// Whether this date is yesterday (handles UTC timestamps correctly).
  bool get isYesterday {
    final local = toLocal();
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return local.year == yesterday.year &&
        local.month == yesterday.month &&
        local.day == yesterday.day;
  }

  /// Whether this date is in the current year.
  bool get isThisYear => toLocal().year == DateTime.now().year;

  /// Returns a human-readable relative time string.
  String get timeAgo {
    final diff = DateTime.now().difference(toLocal());
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (isThisYear) return DateFormat('MMM d').format(this);
    return DateFormat('MMM d, yyyy').format(this);
  }

  /// Formats as "Jan 1, 2025".
  String get formatted => DateFormat('MMM d, yyyy').format(this);

  /// Formats as "January 1, 2025".
  String get formattedLong => DateFormat('MMMM d, yyyy').format(this);

  /// Formats as "01/01/2025".
  String get formattedShort => DateFormat('MM/dd/yyyy').format(this);

  /// Formats as "3:45 PM".
  String get formattedTime => DateFormat('h:mm a').format(this);

  /// Formats as "Jan 1, 2025 3:45 PM".
  String get formattedDateTime => DateFormat('MMM d, yyyy h:mm a').format(this);
}
