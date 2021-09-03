import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class HelpTip extends StatefulWidget {
  const HelpTip({
    required this.message,
    required this.child,
    this.direction = AxisDirection.down,
  });

  final String message;
  final Widget child;
  final AxisDirection direction;

  @override
  State<HelpTip> createState() => _HelpTipState();
}

class _HelpTipState extends State<HelpTip> {
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
    final msg = _wrapString(widget.message);

    if (Preferences.disableTooltips || Utils.isEmpty(msg)) {
      return widget.child;
    }

    return JustTheTooltip(
      // hoverShowDuration: const Duration(milliseconds: 200),dddd
      preferredDirection: widget.direction,
      waitDuration: const Duration(milliseconds: 1200),
      tailLength: 20,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      fadeInDuration: const Duration(milliseconds: 400),
      fadeOutDuration: const Duration(milliseconds: 400),
      tailBaseWidth: 18,
      content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}
