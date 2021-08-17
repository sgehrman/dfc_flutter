import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// wrap this around a scroll view to enable mouse driven scrolling like
// touch ui.  this is disabled by default
class DragScrollWidget extends StatelessWidget {
  const DragScrollWidget({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: child,
    );
  }
}

// ================================================
// ================================================

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
