import 'package:flutter/material.dart';

class StadiumTag extends StatelessWidget {
  const StadiumTag({
    this.tag,
  });

  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const ShapeDecoration(
          shape: StadiumBorder(
            side: BorderSide(
              color: Color.fromRGBO(0, 0, 0, .4),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 14.0,
          ),
          child: Text(
            tag!,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
