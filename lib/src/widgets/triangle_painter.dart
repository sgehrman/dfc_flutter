import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  const TrianglePainter({
    required this.color,
    this.downArrow = false,
  });

  final Color color;
  final bool downArrow;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    final Path path = Path();

    if (downArrow) {
      path.moveTo(rect.topLeft.dx, rect.topLeft.dy);
      path.lineTo(rect.topRight.dx, rect.topRight.dy);
      path.lineTo(rect.bottomCenter.dx, rect.bottomCenter.dy);
    } else {
      path.moveTo(rect.topLeft.dx, rect.topLeft.dy);
      path.lineTo(rect.topRight.dx, rect.centerRight.dy);
      path.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
