import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

final int startTime = DateTime.now().millisecondsSinceEpoch;

class StarField {
  StarField(int starCount) {
    for (int i = 0; i < starCount; i++) {
      stars.add(Star());
    }
  }

  List<Star> stars = [];
}

Random starRandom = Random.secure();

class Star {
  final Vector3 position = Vector3(
      getNormalizedRandom(), getNormalizedRandom(), getNormalizedRandom());
  final int alpha = starRandom.nextInt(128) + 128;
  final int red = starRandom.nextInt(50) + 205;
  final int green = starRandom.nextInt(50) + 205;
  final int blue = starRandom.nextInt(50) + 205;
  final Vector3 screenVector = Vector3.zero();
  Offset screenOffset = Offset.zero;

  static double standardDeviation = 0.5;
  static double mean = 0.5;

  double z = 0;

  static double getNormalizedRandom() => starRandom.nextDouble();
}
