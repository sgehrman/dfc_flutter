import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

// same as Tooltip, but handles null messages without exceptions

class DFTooltip extends StatelessWidget {
  const DFTooltip({
    required this.message,
    required this.child,
  });

  final String? message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(message)) {
      return Tooltip(
        message: message,
        child: child,
      );
    }

    return child;
  }
}
