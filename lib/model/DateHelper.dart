import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DateHelper {
  String convert(String timestamp) {
    initializeDateFormatting();
    int timeInt = int.tryParse(timestamp)!;
    DateTime now = DateTime.now();
    DateTime datePoste = DateTime.fromMillisecondsSinceEpoch(timeInt);
    DateFormat format;

    if (now.difference(datePoste).inDays > 0) {
      format = DateFormat.yMMMd("fr_FR");
    } else {
      format = DateFormat.Hm("fr_FR");
    }

    return format.format(datePoste).toString();
  }
}
