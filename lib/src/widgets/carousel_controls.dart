import 'package:flutter/material.dart';

class CarouselControls extends StatelessWidget {
  const CarouselControls(
      {required this.child,
      required this.onPrevious,
      required this.onNext,
      super.key});

  final Widget child;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton.filled(
              iconSize: 40,
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton.filled(
              iconSize: 40,
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
            ),
          ),
        ),
      ],
    );
  }
}
