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

  String _wrapString(String message) {
    final words = message.split(' ');

    final buffer = StringBuffer();

    int cnt = 0;
    for (final word in words) {
      cnt += word.length;
      buffer.write('$word ');

      if (cnt > 40) {
        cnt = 0;
        buffer.write('\n');
      }
    }

    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(message)) {
      return Tooltip(
        message: _wrapString(message!),
        child: child,
      );
    }

    return child;
  }
}
