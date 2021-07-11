import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:intl/intl.dart';

class Dates {
  static String formatDateString(String iso) {
    final DateTime date = DateTime.parse(iso);

    return formatDateTime(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date != null) {
      final DateTime now = DateTime.now();
      final DateTime yDay = now.subtract(const Duration(days: 1));
      final DateTime yyDay = yDay.subtract(const Duration(days: 1));

      final formatter = DateFormat.MMMd().add_jm();

      if (date.compareTo(yDay) != -1) {
        return 'Today ${formatter.format(date)}';
      } else if (date.compareTo(yyDay) != -1) {
        return 'Yesterday ${formatter.format(date)}';
      } else {
        return formatter.format(date);
      }
    }
    return '';
  }

  // if date is in UTC, use this to get local
  static String formatLocalDateTime({
    required DateTime? date,
    bool addDay = false,
  }) {
    if (date != null) {
      String day = '';

      if (addDay) {
        day = 'E, ';
      }

      final DateFormat formatter = DateFormat('${day}MMM dd, h:mm a');

      return formatter.format(date.toLocal());
    }

    // don't want to crash Text, return '' instead of null
    return '';
  }

  static String formatLocalDateString(String dateString) {
    String? result;

    if (dateString == 'Invalid DateTime') {
      return '';
    }

    if (Utils.isNotEmpty(dateString)) {
      try {
        DateTime? theDate = parseDate(dateString);

        if (theDate != null) {
          // added for medcreds, their dates need utc
          if (!theDate.isUtc) {
            theDate = DateTime.utc(
              theDate.year,
              theDate.month,
              theDate.day,
              theDate.hour,
              theDate.minute,
              theDate.second,
            );
          }

          result = formatLocalDateTime(date: theDate);
        }
      } catch (err) {
        print('Error: dateString: $dateString, err: $err');
      }
    }

    // pass back unchanged on failure
    if (Utils.isEmpty(result)) {
      result = dateString;
    }

    return result ?? '';
  }

  // sometimes you get a weird date format that crashes
  // not a perfect solution, but enough for now
  static DateTime? parseDate(String dateString) {
    if (Utils.isNotEmpty(dateString)) {
      DateTime? theDate;

      try {
        theDate = DateTime.parse(dateString);
      } catch (err) {
        print('Error: dateString: $dateString, err: $err');
      }

      if (theDate != null) {
        return theDate;
      }

      try {
        // try again with DateFormat.parse()
        theDate = DateFormat('MM/dd/yyy HH:mm:ss').parse(dateString);
      } catch (err) {
        print('Error-2: dateString: $dateString, err: $err');
      }

      if (theDate != null) {
        return theDate;
      }
    }

    return null;
  }

  static String fileNameWithDate() {
    String filename = DateFormat.yMd().add_jms().format(DateTime.now());
    filename = filename.replaceAll(':', '-');
    filename = filename.replaceAll('.', '-');
    filename = filename.replaceAll(' ', '-');
    filename = filename.replaceAll('/', '-');

    return filename;
  }

  static String timeOnly({
    required DateTime? date,
  }) {
    if (date != null) {
      final DateFormat formatter = DateFormat('h:mma');

      return formatter.format(date.toLocal());
    }

    // don't want to crash Text, return '' instead of null
    return '';
  }
}
