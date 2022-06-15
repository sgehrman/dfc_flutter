import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class CheckerboardContainer extends Container {
  CheckerboardContainer({
    Color? color,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Widget? child,
  }) : super(
          constraints: constraints,
          padding: padding,
          margin: margin,
          color: color,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: CheckerboardPainter(darkMode: Utils.isDarkMode(context)),
            ),
          ),
          super.build(context),
        ],
      ),
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

    final Color fillColor = darkMode! ? Colors.black : Colors.white;
    final Color blockColor = darkMode!
        ? const Color.fromRGBO(255, 255, 255, 0.08)
        : const Color.fromRGBO(0, 0, 0, 0.08);

    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawRect(rect, paint);

    // calc block size so there are
    const double blockDim = 16;

    double yOffset = 0;
    const Size rectSize = Size(blockDim, blockDim);
    int yIndex = 0;

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
