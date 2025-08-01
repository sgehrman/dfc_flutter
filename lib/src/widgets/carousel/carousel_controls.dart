import 'package:dfc_flutter/src/widgets/hover_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CarouselControls extends StatelessWidget {
  const CarouselControls(
      {required this.child,
      required this.onPrevious,
      required this.onNext,
      this.showOnHover = false,
      super.key});

  final Widget child;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool showOnHover;

  @override
  Widget build(BuildContext context) {
    return HoverOverlay(builder: (hoverState) {
      final show = !showOnHover || hoverState == HoverState.entered;

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
          )
              .animate(
                target: show ? 1 : 0,
              )
              .fade(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
                begin: 0,
                end: 1,
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
          )
              .animate(
                target: show ? 1 : 0,
              )
              .fade(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 400),
                begin: 0,
                end: 1,
              ),
        ],
      );
    });
  }
}
