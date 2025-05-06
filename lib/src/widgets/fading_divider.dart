import 'package:flutter/material.dart';

class FadingDivider extends StatelessWidget {
  const FadingDivider({
    this.height = 0,
    this.thickness = 1,
    this.color,
  });

  final double height;
  final double thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var dividerColor = Theme.of(context).dividerColor;

    if (color != null) {
      dividerColor = color!;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height == 0 ? 0 : height / 2),
      child: SizedBox(
        height: thickness,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0),
                dividerColor,
                dividerColor,
                Colors.white.withValues(alpha: 0),
              ],
              stops: const [0, 0.1, 0.9, 1],
            ),
          ),
        ),
      ),
    );
  }
}
