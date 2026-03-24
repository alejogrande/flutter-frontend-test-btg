import 'package:intl/intl.dart';

class AppFormatters {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '\$',
    decimalDigits: 0,
  );

  static String toCurrency(double value) {
    return _currencyFormat.format(value);
  }

  static String toPercentage(double value) {
    return '${value.toStringAsFixed(2)}%';
  }


static String formatDate(DateTime date) {
  return DateFormat('dd MMM yyyy', 'es_CO').format(date);
}
}