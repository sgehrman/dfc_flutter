import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckerboardContainer extends StatelessWidget {
  const CheckerboardContainer({
    required this.child,
    this.enabled = true,
  });

  final Widget child;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Positioned.fill(
          child: CustomPaint(
            painter: CheckerboardPainter(darkMode: Utils.isDarkMode(context)),
          ),
        ),
        child,
      ],
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  const CheckerboardPainter({this.darkMode});

  final bool? darkMode;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);

    // final Color fillColor = darkMode! ? Colors.black : Colors.white;
    final blockColor = darkMode!
        ? const Color.fromRGBO(255, 255, 255, 0.08)
        : const Color.fromRGBO(0, 0, 0, 0.08);

    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
    // ..color = fillColor;
    // canvas.drawRect(rect, paint);

    const double blockDim = 15;

    double yOffset = 0;
    const rectSize = Size(blockDim, blockDim);
    var yIndex = 0;

    paint.color = blockColor;
    while (yOffset < size.height) {
      double xOffset = 0;

      if (yIndex % 2 != 0) {
        xOffset += rectSize.width;
      }

      while (xOffset < size.width) {
        canvas.drawRect(Offset(xOffset, yOffset) & rectSize, paint);

        xOffset += rectSize.width * 2;
      }
      yOffset += rectSize.height;
      yIndex++;
    }

    paint.style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
