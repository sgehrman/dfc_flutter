import 'package:flutter/material.dart';

class ContentOverflowFader extends StatelessWidget {
  const ContentOverflowFader(
      {required this.color, required this.child, this.gradientWidth = 80});

  final Color color;
  final Widget child;
  final double gradientWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      Positioned.fill(
        child: _GradientWidget(
          color: color,
          gradientWidth: gradientWidth,
        ),
      ),
    ]);
  }
}

// ===========================================================

class _GradientWidget extends StatelessWidget {
  const _GradientWidget({required this.color, required this.gradientWidth});

  final Color color;
  final double gradientWidth;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: CustomPaint(painter: _GradientPainter(color, gradientWidth)),
      ),
    );
  }
}

// =======================================================

class _GradientPainter extends CustomPainter {
  const _GradientPainter(this.color, this.gradientWidth);

  final Color color;
  final double gradientWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paints =
        _GradientCache().paints(rect, color, gradientWidth: gradientWidth);

    canvas.drawRect(paints.leftRect, paints.left);
    canvas.drawRect(paints.rightRect, paints.right);
  }

  // =================================================

  @override
  bool shouldRepaint(covariant _GradientPainter oldDelegate) {
    return false;
  }
}

// ===========================================================

class _GradientCache {
  factory _GradientCache() {
    return _instance ??= _GradientCache._();
  }
  _GradientCache._();

  static _GradientCache? _instance;

  _GradientPaints _paints = _GradientPaints(
    color: Colors.black,
    left: Paint(),
    right: Paint(),
    rect: Rect.zero,
    leftRect: Rect.zero,
    rightRect: Rect.zero,
  );

  _GradientPaints paints(Rect rect, Color color,
      {required double gradientWidth}) {
    if (_paints.hasChanged(rect, color)) {
      final leftRect = Rect.fromLTWH(
        rect.left,
        rect.top,
        gradientWidth,
        rect.height,
      );

      final leftPaint = Paint();
      leftPaint.shader = LinearGradient(
        colors: [color, color.withValues(alpha: 0)],
      ).createShader(leftRect);

      final rightRect = Rect.fromLTWH(
        rect.right - gradientWidth,
        rect.top,
        gradientWidth,
        rect.height,
      );

      final rightGradient = Paint();
      rightGradient.shader = LinearGradient(
        colors: [color.withValues(alpha: 0), color],
      ).createShader(rightRect);

      _paints = _GradientPaints(
        color: color,
        left: leftPaint,
        right: rightGradient,
        leftRect: leftRect,
        rightRect: rightRect,
        rect: rect,
      );
    }

    return _paints;
  }
}

// ===========================================================

class _GradientPaints {
  _GradientPaints({
    required this.color,
    required this.rect,
    required this.left,
    required this.right,
    required this.leftRect,
    required this.rightRect,
  });

  Color color;
  Paint left;
  Paint right;

  Rect rect;
  Rect leftRect;
  Rect rightRect;

  bool hasChanged(Rect rect, Color color) {
    return color != this.color || rect != this.rect;
  }
}
