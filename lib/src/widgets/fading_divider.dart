import 'package:flutter/material.dart';

class FadingDivider extends StatelessWidget {
  const FadingDivider({
    this.height = 1,
    this.color,
  });

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color dividerColor = Theme.of(context).dividerColor;

    if (color != null) {
      dividerColor = color!;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height == 0 ? 0 : height / 2),
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                dividerColor,
                dividerColor,
                Colors.transparent,
              ],
              stops: const [0, 0.1, 0.9, 1],
            ),
          ),
        ),
      ),
    );
  }
}
