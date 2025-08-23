import 'package:intl/intl.dart';

class DateTimeUtils {
  static String format(String dateTimeStr) {
    return DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.parse(dateTimeStr).toLocal());
  }
}
