import 'package:intl/intl.dart';

/// Utility class for formatting currency values.
abstract class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 2,
  );

  static final NumberFormat _compactFormatter = NumberFormat.compact(
    locale: 'en_US',
  );

  /// Formats a double amount into 'Rs. 1,250.00' format.
  static String format(double amount) {
    return _formatter.format(amount);
  }

  /// Formats a double into compact representation e.g. 'Rs. 1.2K'
  static String formatCompact(double amount) {
    return 'Rs. ${_compactFormatter.format(amount)}';
  }
}
