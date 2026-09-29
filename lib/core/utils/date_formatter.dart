import 'package:intl/intl.dart';

/// Utility class for standardizing date formatting across the app.
abstract class DateFormatter {
  static final DateFormat _dayMonthYear = DateFormat('d MMM yyyy'); // e.g. 29 Sep 2026
  static final DateFormat _monthYear = DateFormat('MMMM yyyy'); // e.g. September 2026
  static final DateFormat _numericDate = DateFormat('dd/MM/yyyy'); // e.g. 29/09/2026
  static final DateFormat _shortMonthDay = DateFormat('d MMM'); // e.g. 29 Sep

  /// Returns date formatted as '29 Sep 2026'
  static String formatFullDate(DateTime date) => _dayMonthYear.format(date);

  /// Returns date formatted as 'September 2026'
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  /// Returns date formatted as '29/09/2026'
  static String formatNumericDate(DateTime date) => _numericDate.format(date);

  /// Returns date formatted as '29 Sep'
  static String formatShortDate(DateTime date) => _shortMonthDay.format(date);

  /// Checks if two dates belong to the same year and month.
  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  /// Checks if two dates belong to the same day.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
