import 'package:dfc_flutter/dfc_flutter.dart';
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
            painter: CheckerboardPainter(
                blockColor: context.primary.withValues(alpha: 0.3)),
          ),
        ),
        child,
      ],
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  const CheckerboardPainter({required this.blockColor});

  final Color blockColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);

    final paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill
      ..color = blockColor;

    const double blockDim = 15;

    var yOffset = size.height;
    const rectSize = Size(blockDim, blockDim);
    var yIndex = 0;

    while (yOffset > -blockDim) {
      double xOffset = 0;

      if (yIndex.isOdd) {
        xOffset += rectSize.width;
      }

      while (xOffset < size.width) {
        canvas.drawRect(Offset(xOffset, yOffset) & rectSize, paint);

        xOffset += rectSize.width * 2;
      }
      yOffset -= rectSize.height;
      yIndex++;
    }

    paint.style = PaintingStyle.stroke;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
