import 'package:intl/intl.dart';

/// French clock-time label for a "live since" timestamp — "depuis 21h30",
/// not an elapsed duration (that's `DateTimeX.timeAgo`, English and the
/// wrong semantic for this use).
extension LiveSinceX on DateTime {
  String get liveSinceLabel =>
      'depuis ${DateFormat("HH'h'mm").format(toLocal())}';
}
