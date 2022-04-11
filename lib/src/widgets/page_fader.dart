import 'package:flutter/material.dart';

class PageFader extends StatelessWidget {
  const PageFader(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: PageFaderPainter(
          color: color,
        ),
      ),
    );
  }
}

class PageFaderPainter extends CustomPainter {
  const PageFaderPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final leftRect = Rect.fromLTWH(rect.left, rect.top, 10, rect.height);
    final rightRect = Rect.fromLTWH(rect.right - 10, rect.top, 10, rect.height);

    final paint = Paint();
    paint.isAntiAlias = true;
    paint.style = PaintingStyle.fill;
    paint.shader = LinearGradient(
      colors: [
        color,
        color.withOpacity(0),
      ],
    ).createShader(leftRect);

    canvas.drawRect(
      leftRect,
      paint,
    );

    paint.shader = LinearGradient(
      colors: [
        color.withOpacity(0),
        color,
      ],
    ).createShader(rightRect);

    canvas.drawRect(
      rightRect,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
