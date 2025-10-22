import 'package:flutter/material.dart';

// make the key visible so it won't accidentally get removed
// should be top most widget in a list or grid as needed
class RequiredKey extends StatelessWidget {
  const RequiredKey({
    required super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
