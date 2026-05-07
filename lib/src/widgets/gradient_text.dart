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
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

class FireText extends StatelessWidget {
  const FireText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          colors: <Color>[Colors.yellow, Colors.deepOrange.shade900],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final gradient = LinearGradient(
          colors: colors,
          transform: transform,
        );

        final shader = gradient.createShader(
          Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxWidth),
        );

        final baseStyle = textStyle ?? const TextStyle();

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: firstText, style: baseStyle),
              TextSpan(
                text: secondText,
                style: baseStyle.copyWith(
                  foreground: Paint()..shader = shader,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
