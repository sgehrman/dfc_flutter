import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
    this.onTap, // not needed in a PopupMenuItem
  });

  final String name;
  final Icon? icon;
  final int level;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.only(left: level * 20),
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
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
