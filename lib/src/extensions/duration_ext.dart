import 'package:dfc_flutter/src/extensions/num_ext.dart';

extension ExtendedDuration on Duration {
  String get elapsedString {
    return '$hoursString : $minutesString : $secondsString : $tenthsString';
  }

  String get hoursString {
    final Duration e = this;

    final int hours = e.inHours;

    return hours.remainder(24).twoDigitTime;
  }

  String get secondsString {
    final Duration e = this;

    final int secs = e.inSeconds;

    return secs.remainder(60).twoDigitTime;
  }

  String get minutesString {
    final Duration e = this;

    final int mins = e.inMinutes;

    return mins.remainder(60).twoDigitTime;
  }

  String get tenthsString {
    final Duration e = this;

    final int tenths = e.inMilliseconds;

    num tens = tenths.remainder(1000);
    tens = tens ~/ 10;

    return tens.toInt().twoDigitTime;
  }

  int get hours {
    return inHours.remainder(12);
  }

  int get minutes {
    return inMinutes.remainder(60);
  }

  int get seconds {
    return inSeconds.remainder(60);
  }

  int get milliseconds {
    return inMilliseconds.remainder(60000);
  }
}
