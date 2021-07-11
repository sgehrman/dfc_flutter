import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({this.name, this.icon});

  final String? name;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: icon,
        ),
        Flexible(
          child: Text(
            name ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
