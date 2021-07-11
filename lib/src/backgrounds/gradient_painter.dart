import 'package:flutter/material.dart';

class GradientPainter extends CustomPainter {
  GradientPainter({
    required this.value,
    required this.startColor,
    required this.endColor,
  });

  final double value;
  final Color startColor;
  final Color endColor;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    const bool fullScreen = false;

    // covert the appbar and status bar
    // ignore: dead_code
    if (fullScreen) {
      rect = Rect.fromLTRB(rect.left, rect.top - 100, rect.right, rect.bottom);
    }

    final sColor = Color.lerp(startColor, endColor, value);
    final eColor = Color.lerp(endColor, startColor, value);

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        sColor!,
        eColor!,
      ],
    );

    final Paint fillPaint = Paint();
    fillPaint.shader = gradient.createShader(rect);

    canvas.drawRect(rect, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
