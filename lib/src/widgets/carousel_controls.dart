import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
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
              color: context.primary,
              iconSize: 44,
              onPressed: onNext,
              icon: Icon(Icons.chevron_right, color: context.onPrimary),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: IconButton.filled(
              color: context.primary,
              iconSize: 44,
              onPressed: onPrevious,
              icon: Icon(Icons.chevron_left, color: context.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
