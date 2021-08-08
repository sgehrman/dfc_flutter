import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
  });

  final String name;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        name,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
