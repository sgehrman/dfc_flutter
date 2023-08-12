import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WidgetPopButton extends StatefulWidget {
  const WidgetPopButton({required this.builder, super.key});

  final Widget Function(void Function() pop) builder;

  @override
  State<WidgetPopButton> createState() => _WidgetPopButtonState();
}

class _WidgetPopButtonState extends State<WidgetPopButton> {
  AnimationController? _controller;

  @override
  Widget build(BuildContext context) {
    return widget
        .builder(() {
          _controller?.reverse(from: 1);
        })
        .animate(
          autoPlay: false,
          onInit: (c) {
            _controller = c;
          },
        )
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.5, 1.5),
        );
  }
}
