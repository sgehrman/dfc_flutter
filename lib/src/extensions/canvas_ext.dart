import 'dart:math';

import 'package:flutter/material.dart';

extension ExtendedCanvas on Canvas {
  void drawPetals({
    required Color color,
    required Color highlightColor,
    required double radius,
    int petals = 14,
    double xPetalWeightDivisor = 2.0,
    double yPetalWeightDivisor = 2.0,
    double radiusDivisor = 2.2,
    double opacity = 0.5,
  }) {
    final strokeWidth = radius / 107;

    final petalShader = RadialGradient(
      colors: [
        highlightColor.withValues(alpha: opacity),
        color.withValues(alpha: opacity),
      ],
      stops: const [
        0,
        0.5,
      ],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = petalShader;

    for (var i = 0; i < petals; i++) {
      save();

      rotate(2 * pi / petals * i);
      _drawPetal(
        paint: paint,
        radius: radius / radiusDivisor,
        xPetalWeightDivisor: xPetalWeightDivisor,
        yPetalWeightDivisor: yPetalWeightDivisor,
      );

      restore();
    }
  }

  void _drawPetal({
    required Paint paint,
    required double radius,
    required double xPetalWeightDivisor,
    required double yPetalWeightDivisor,
  }) {
    final path = Path();

    path.moveTo(0, 0);

    path.quadraticBezierTo(
      -radius / xPetalWeightDivisor,
      radius / yPetalWeightDivisor,
      0,
      radius,
    );

    path.quadraticBezierTo(
      radius / xPetalWeightDivisor,
      radius / yPetalWeightDivisor,
      0,
      0,
    );

    path.close();

    drawShadow(path, Colors.black, 1, false);
    drawPath(path, paint);
  }
}
