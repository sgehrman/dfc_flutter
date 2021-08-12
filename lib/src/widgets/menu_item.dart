import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
  });

  final String name;
  final Icon? icon;
  final int level;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: level * 20),
      dense: true,
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
    );
  }
}
