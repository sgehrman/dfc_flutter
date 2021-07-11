import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/backgrounds/star_field/star_field.dart';
import 'package:dfc_flutter/src/backgrounds/star_field/star_field_painter.dart';

class StarfieldBackground extends StatelessWidget {
  const StarfieldBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Positioned.fill(child: AnimatedBackground()),
        const Positioned.fill(child: StarFieldContainingStatefulWidget()),
        Positioned.fill(child: child),
      ],
    );
  }
}

class MainScreenViewModel {
  const MainScreenViewModel(this.count, this.starField);
  final double count;
  final StarField starField;
}

class StarFieldContainingStatefulWidget extends StatefulWidget {
  const StarFieldContainingStatefulWidget();

  @override
  State<StatefulWidget> createState() {
    return StarFieldState();
  }
}

class StarFieldState extends State<StarFieldContainingStatefulWidget>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  late AnimationController controller;
  final MainScreenViewModel viewModel =
      MainScreenViewModel(600, StarField(600));

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(days: 1000), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => CustomPaint(
          painter: StarFieldPainter(viewModel.starField, viewModel.count),
          size: Size.infinite),
    );
  }
}
