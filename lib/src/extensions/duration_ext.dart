import 'package:dfc_flutter/src/extensions/num_ext.dart';

extension ExtendedDuration on Duration {
  String get elapsedString {
    return '$hoursString : $minutesString : $secondsString : $tenthsString';
  }

  String get hoursString {
    final Duration e = this;

    final int hours = e.inHours;

    final String hoursString = hours.remainder(24).toInt().twoDigitTime;

    return hoursString;
  }

  String get secondsString {
    final Duration e = this;

    final int secs = e.inSeconds;

    final String secString = secs.remainder(60).toInt().twoDigitTime;

    return secString;
  }

  String get minutesString {
    final Duration e = this;

    final int mins = e.inMinutes;

    final String minString = mins.remainder(60).toInt().twoDigitTime;

    return minString;
  }

  String get tenthsString {
    final Duration e = this;

    final int tenths = e.inMilliseconds;

    num tens = tenths.remainder(1000);
    tens = tens ~/ 10;

    final String tenthsString = tens.toInt().twoDigitTime;

    return tenthsString;
  }

  int get hours {
    return inHours.remainder(12).toInt();
  }

  int get minutes {
    return inMinutes.remainder(60).toInt();
  }

  int get seconds {
    return inSeconds.remainder(60).toInt();
  }

  int get milliseconds {
    return inMilliseconds.remainder(60000).toInt();
  }
}
