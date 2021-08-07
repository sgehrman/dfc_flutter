import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({this.name, this.iconData});

  final String? name;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Icon(iconData, color: Colors.black87),
        ),
        Flexible(
          child: Text(
            name ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
