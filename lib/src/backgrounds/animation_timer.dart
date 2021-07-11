import 'dart:math' as math;
import 'package:supercharged/supercharged.dart';

class AnimationTimer {
  static final random = math.Random();

  late Duration _duration;
  Duration? _startTime;

  void restart(Duration duration) {
    Duration now = DateTime.now().duration();
    bool scatter = _startTime == null;

    if (!scatter) {
      scatter = (now - _startTime!) > duration * 2;
    }

    if (scatter) {
      now = now - (duration * (random.nextDouble() * .8));
    }

    _duration = duration;
    _startTime = now;
  }

  double _progress(Duration now) {
    return (now - _startTime!) / _duration;
  }

  double progress(Duration now) {
    return _progress(now).clamp(0.0, 1.0).toDouble();
  }
}
