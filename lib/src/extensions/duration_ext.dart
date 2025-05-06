import 'package:dfc_flutter/src/extensions/num_ext.dart';

extension ExtendedDuration on Duration {
  String get elapsedString {
    return '$hoursString : $minutesString : $secondsString : $tenthsString';
  }

  String get shortElapsedString {
    final e = this;

    if (e.inHours == 0) {
      // no leading zero of first numbers
      final minsStr = e.inMinutes.remainder(60);

      return '$minsStr:$secondsString';
    }

    // no leading zero of first numbers
    final hrsStr = e.inHours.remainder(24);

    return '$hrsStr:$minutesString:$secondsString';
  }

  String get hoursString {
    final e = this;

    final hours = e.inHours;

    return hours.remainder(24).twoDigitTime;
  }

  String get secondsString {
    final e = this;

    final secs = e.inSeconds;

    return secs.remainder(60).twoDigitTime;
  }

  String get minutesString {
    final e = this;

    final mins = e.inMinutes;

    return mins.remainder(60).twoDigitTime;
  }

  String get tenthsString {
    final e = this;

    final tenths = e.inMilliseconds;

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
