import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.textStyle,
  });

  factory GradientText.rainbow(
    String text, {
    GradientTransform? transform,
    TextStyle? textStyle,
  }) {
    final colors = <Color>[
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.red,
    ];

    return GradientText.colors(text,
        colors: colors, transform: transform, textStyle: textStyle);
  }

  factory GradientText.colors(
    String text, {
    required List<Color> colors,
    GradientTransform? transform,
    TextStyle? textStyle,
  }) {
    final gradient = LinearGradient(
      colors: colors,
      transform: transform,
    );

    return GradientText(text, gradient: gradient, textStyle: textStyle);
  }

  final String text;
  final TextStyle? textStyle;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final baseStyle = defaultStyle.merge(textStyle);
    final textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: baseStyle),
          textDirection: textDirection,
        )..layout(maxWidth: constraints.maxWidth);

        return Semantics(
          label: text,
          child: CustomPaint(
            size: painter.size,
            painter: _GradientSpanPainter(
              painter: painter,
              gradientStart: 0,
              gradientEnd: text.length,
              gradient: gradient,
            ),
          ),
        );
      },
    );
  }
}

class FireText extends StatelessWidget {
  const FireText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return GradientText(
      text,
      gradient: RadialGradient(
        center: Alignment.topLeft,
        radius: 1,
        colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
        tileMode: TileMode.mirror,
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 40,
      ),
    );
  }
}

class GradientMultiText extends StatelessWidget {
  const GradientMultiText(
    this.firstText,
    this.secondText, {
    required this.colors,
    this.transform,
    this.textStyle,
  });

  final String firstText;
  final String secondText;
  final List<Color> colors;
  final GradientTransform? transform;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final baseStyle = defaultStyle.merge(textStyle);
    final textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: firstText),
              TextSpan(text: secondText),
            ],
          ),
          textDirection: textDirection,
        )..layout(maxWidth: constraints.maxWidth);

        return Semantics(
          label: '$firstText$secondText',
          child: CustomPaint(
            size: painter.size,
            painter: _GradientSpanPainter(
              painter: painter,
              gradientStart: firstText.length,
              gradientEnd: firstText.length + secondText.length,
              gradient: LinearGradient(colors: colors, transform: transform),
            ),
          ),
        );
      },
    );
  }
}

class _GradientSpanPainter extends CustomPainter {
  _GradientSpanPainter({
    required this.painter,
    required this.gradientStart,
    required this.gradientEnd,
    required this.gradient,
  });

  final TextPainter painter;
  final int gradientStart;
  final int gradientEnd;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    painter.paint(canvas, Offset.zero);

    final boxes = painter.getBoxesForSelection(
      TextSelection(baseOffset: gradientStart, extentOffset: gradientEnd),
    );

    for (final box in boxes) {
      final rect = box.toRect();
      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..blendMode = BlendMode.srcATop;
      canvas.drawRect(rect, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GradientSpanPainter oldDelegate) {
    return oldDelegate.painter != painter ||
        oldDelegate.gradientStart != gradientStart ||
        oldDelegate.gradientEnd != gradientEnd ||
        oldDelegate.gradient != gradient;
  }
}
