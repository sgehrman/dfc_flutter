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
  final Icon? icon;
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
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
