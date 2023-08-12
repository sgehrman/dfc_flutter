import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:intl/intl.dart';

class Dates {
  static String formatDateString(String iso) {
    return formatDateTime(DateTime.tryParse(iso));
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
        final yearFormatter = DateFormat.yMMMd().add_jm();

        return yearFormatter.format(date);
      }
    }

    return '';
  }

  static String formatInDays(DateTime dateTime) {
    final today = DateTime.now();
    final difference = dateTime.difference(today);

    return switch (difference) {
      Duration(inDays: 0) => 'Today',
      Duration(inDays: 1) => 'Tomorrow',
      Duration(inDays: -1) => 'Yesterday',
      Duration(inDays: final days) when days > 7 =>
        '${days ~/ 7} weeks from now', // Add from here
      Duration(inDays: final days) when days < -7 =>
        '${days.abs() ~/ 7} weeks ago', // to here.
      Duration(inDays: final days, isNegative: true) =>
        '${days.abs()} days ago',
      Duration(inDays: final days) => '$days days from now',
    };
  }

  static String formatLongDate(DateTime? date) {
    if (date != null) {
      final formatter = DateFormat('EE, MMM d, yyyy');

      return formatter.format(date);
    }

    return '';
  }

  // 2022-10-31
  static String formatShortDate(DateTime? date) {
    if (date != null) {
      final formatter = DateFormat('y-MM-dd');

      return formatter.format(date);
    }

    return '';
  }

  // if date is in UTC, use this to get local
  static String formatLocalDateTime({
    required DateTime? date,
    bool addDay = false,
    bool addSeconds = false,
  }) {
    if (date != null) {
      String day = '';

      if (addDay) {
        day = 'E, ';
      }

      String secs = '';

      if (addSeconds) {
        secs = ':ss';
      }

      final DateFormat formatter = DateFormat('${day}MMM dd, h:mm$secs a');

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
      final DateTime? theDate = DateTime.tryParse(dateString);
      if (theDate != null) {
        return theDate;
      }

      try {
        // try again with DateFormat.parse()
        return DateFormat('MM/dd/yyy HH:mm:ss').parse(dateString);
      } catch (err) {
        // print('Error-1: dateString: $dateString, err: $err');
      }

      try {
        // 2021-07-24 2:32
        return DateFormat('yyy-MM-dd HH:mm').parse(dateString);
      } catch (err) {
        // print('Error-2: dateString: $dateString, err: $err');
      }

      try {
        // used in RSS feeds
        // Sun, 06 Aug 2023 17:00:00 +0000
        return DateFormat('E, dd MMM yyyy H:mm:ss').parse(dateString);
      } catch (err) {
        // print('Error-3: dateString: $dateString, err: $err');
      }
    }

    print('Error: Dates.parseDate failed: $dateString');

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
      final DateFormat formatter = DateFormat('h:mm a');

      return formatter.format(date.toLocal());
    }

    // don't want to crash Text, return '' instead of null
    return '';
  }
}
