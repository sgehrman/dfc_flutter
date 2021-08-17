import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

class TreasureAnimation extends StatefulWidget {
  @override
  _TreasureAnimationState createState() => _TreasureAnimationState();
}

class _TreasureAnimationState extends State<TreasureAnimation> {
  final FlareControls _controller = FlareControls();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        _controller.play('box');
      },
      child: SizedBox(
        height: 300,
        width: 300,
        child: FlareActor(
          'packages/dfc_flutter/assets/animations/treasure.flr',
          controller: _controller,
          color: Theme.of(context).primaryColor,
          animation: 'box',
        ),
      ),
    );
  }
}
