import 'package:intl/intl.dart';

class DateFormatter {

  static String formatToString(DateTime date, bool includeTime) {
    late DateFormat formatter;
    date = date.subtract(Duration(hours: 3));

    if (includeTime) {
      formatter = DateFormat('dd/MM/yyyy HH:mm');
    } else {
      formatter = DateFormat('dd/MM/yyyy');
    }

    return formatter.format(date);
  }
}