import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.textStyle,
    this.textAlign = TextAlign.start,
  });

  factory GradientText.rainbow(
    String text, {
    GradientTransform? transform,
    TextStyle? textStyle,
    TextAlign textAlign = TextAlign.start,
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
        colors: colors,
        transform: transform,
        textStyle: textStyle,
        textAlign: textAlign);
  }

  factory GradientText.colors(
    String text, {
    required List<Color> colors,
    GradientTransform? transform,
    TextStyle? textStyle,
    TextAlign textAlign = TextAlign.start,
  }) {
    final gradient = LinearGradient(
      colors: colors,
      transform: transform,
    );

    return GradientText(text,
        gradient: gradient, textStyle: textStyle, textAlign: textAlign);
  }

  final String text;
  final TextStyle? textStyle;
  final Gradient gradient;
  final TextAlign textAlign;

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
          textAlign: textAlign,
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
    this.textAlign = TextAlign.start,
  });

  final String firstText;
  final String secondText;
  final List<Color> colors;
  final GradientTransform? transform;
  final TextStyle? textStyle;
  final TextAlign textAlign;

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
          textAlign: textAlign,
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

    var totalWidth = 0.0;
    for (final box in boxes) {
      totalWidth += box.right - box.left;
    }

    var cumulative = 0.0;
    for (final box in boxes) {
      final rect = box.toRect();
      final shaderRect = Rect.fromLTWH(
        rect.left - cumulative,
        rect.top,
        totalWidth,
        rect.height,
      );
      final paint = Paint()
        ..shader = gradient.createShader(shaderRect)
        ..blendMode = BlendMode.srcATop;

      // if the text's height is 1 for example, the gradient will bleed over
      // to the line above and will look weird.
      final delta = rect.height * 0.05;
      final drawRect = Rect.fromLTRB(
          rect.left, rect.top + delta, rect.right, rect.bottom - delta);

      canvas.drawRect(drawRect, paint);

      cumulative += rect.width;
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
