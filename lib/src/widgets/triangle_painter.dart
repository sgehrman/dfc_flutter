import 'package:dfc_flutter/src/utils/utils.dart';
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

  // ==============================================================
  // Using the Icons.arrow_drop_down wastes space, this is more exact

  static Widget downArrowIcon({
    required BuildContext context,
    EdgeInsets padding = EdgeInsets.zero,
    double width = 13,
    double height = 8,
  }) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 8,
        width: 13,
        child: CustomPaint(
          painter: TrianglePainter(
            color: Utils.isDarkMode(context) ? Colors.white : Colors.black54,
            downArrow: true,
          ),
        ),
      ),
    );
  }
}
