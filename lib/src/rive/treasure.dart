import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class TreasureAnimation extends StatefulWidget {
  @override
  State<TreasureAnimation> createState() => _TreasureAnimationState();
}

class _TreasureAnimationState extends State<TreasureAnimation> {
  late RiveAnimationController<dynamic> _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('box');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        // _controller.play('box');
      },
      child: SizedBox(
        height: 300,
        width: 300,
        child: RiveAnimation.asset(
          'assets/animations/treasure.flr',
          // color: Theme.of(context).primaryColor,
          controllers: [_controller],
          // Update the play state when the widget's initialized
          // onInit: (_) => setState(() { _isPlaying = false}),
        ),
      ),
    );
  }
}
