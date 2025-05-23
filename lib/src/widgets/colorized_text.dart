import 'dart:math' as math;

import 'package:dfc_flutter/src/widgets/gradient_text.dart';
import 'package:flutter/material.dart';

class RotatingRainbowText extends StatefulWidget {
  const RotatingRainbowText({
    required this.text,
    this.textStyle,
  });

  final String text;
  final TextStyle? textStyle;

  @override
  State<RotatingRainbowText> createState() => _RotatingRainbowTextState();
}

class _RotatingRainbowTextState extends State<RotatingRainbowText>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600) * widget.text.length,
    );

    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    return _ColorizeAnimatedText(
      text: widget.text,
      textStyle: widget.textStyle,
      animation: animation,
    );
  }
}

class _ColorizeAnimatedText extends StatelessWidget {
  const _ColorizeAnimatedText({
    required this.text,
    required this.textStyle,
    required this.animation,
  });

  final String text;
  final TextStyle? textStyle;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return GradientText.rainbow(
          text,
          textStyle: textStyle,
          transform: GradientRotation((4 * math.pi) * animation.value),
        );
      },
    );
  }
}
