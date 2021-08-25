import 'package:dfc_flutter/src/themes/platform_sizes.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
    this.onTap, // not needed in a PopupMenuItem
    this.horizontalPadding = 10,
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
      left: horizontalPadding + (level * 20),
    );

    return ListTile(
      onTap: onTap,
      contentPadding: contentPadding,
      minVerticalPadding: 0,
      dense: true,
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 0,
      // IntrinsicWidth keeps the width of the icon without expanding endlessly
      leading: icon != null
          ? IntrinsicWidth(
              child: Container(
                alignment: Alignment.centerLeft,
                child: icon,
              ),
            )
          : null,
      title: Text(
        name,
        style: TextStyle(fontSize: kFontSize.m),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
