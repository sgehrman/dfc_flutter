import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.textStyle,
  });

  factory GradientText.rainbow(String text,
      {GradientTransform? transform, TextStyle? textStyle}) {
    final gradient = LinearGradient(
      colors: const <Color>[
        Colors.red,
        Colors.pink,
        Colors.purple,
        Colors.deepPurple,
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
      ],
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
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1.0,
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
