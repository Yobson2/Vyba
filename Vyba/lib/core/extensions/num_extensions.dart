import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Numeric utility extensions.
extension NumX on num {
  /// Formats the number as currency (e.g. "$1,234.56").
  String toCurrency({String symbol = r'$', int decimalDigits = 2}) {
    return NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }

  /// Formats with thousand separators (e.g. "1,234").
  String get formatted => NumberFormat('#,##0').format(this);

  /// Formats as compact (e.g. "1.2K", "3.4M").
  String get compact => NumberFormat.compact().format(this);

  /// Returns a horizontal [SizedBox] with this width.
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Returns a vertical [SizedBox] with this height.
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Returns a [Duration] of this many milliseconds.
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Returns a [Duration] of this many seconds.
  Duration get seconds => Duration(seconds: toInt());

  /// Returns a [Duration] of this many minutes.
  Duration get minutes => Duration(minutes: toInt());

  /// Returns a [BorderRadius] with this value on all corners.
  BorderRadius get borderRadius =>
      BorderRadius.all(Radius.circular(toDouble()));

  /// Returns [EdgeInsets] with this value on all sides.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());
}
