import 'package:dfc_flutter/src/themes/platform_sizes.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
    this.onTap, // not needed in a PopupMenuItem
    this.horizontalPadding = 20,
  });

  final String name;
  final Widget? icon;
  final int level;
  final void Function()? onTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsets.only(
      right: horizontalPadding,
      left: horizontalPadding + (level * horizontalPadding),
      top: 4,
      bottom: 4,
    );

    Widget leading = const SizedBox();
    if (icon != null) {
      leading = icon!;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: contentPadding,
        child: Row(
          children: [
            leading,
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(fontSize: kFontSize.m),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
