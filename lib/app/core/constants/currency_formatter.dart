import 'package:intl/intl.dart';

class CurrencyFormatter {

  static String format(double amount) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(amount);
  }
}