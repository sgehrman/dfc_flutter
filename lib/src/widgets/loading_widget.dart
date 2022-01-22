import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Theme.of(context).primaryColor,
        size: size,
      ),

      // child: SizedBox(
      //   height: 64,
      //   width: 64,
      //   child: CircularProgressIndicator(
      //     color: Theme.of(context).primaryColor,
      //     strokeWidth: 6,
      //   ),
      // ),
    );
  }
}
