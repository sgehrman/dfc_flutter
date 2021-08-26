import 'dart:async';

import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

enum HelpTipDirection {
  up,
  down,
  right,
  left,
}

class HelpTip extends StatefulWidget {
  const HelpTip({
    required this.message,
    required this.child,
    this.direction = HelpTipDirection.down,
  });

  final String message;
  final Widget child;
  final HelpTipDirection direction;

  @override
  State<HelpTip> createState() => _HelpTipState();
}

class _HelpTipState extends State<HelpTip> {
  bool _show = false;
  Timer? _showTimer;

  @override
  void dispose() {
    _showTimer?.cancel();

    super.dispose();
  }

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

    TooltipDirection direction;

    switch (widget.direction) {
      case HelpTipDirection.down:
        direction = TooltipDirection.down;
        break;
      case HelpTipDirection.up:
        direction = TooltipDirection.up;
        break;
      case HelpTipDirection.right:
        direction = TooltipDirection.right;
        break;
      case HelpTipDirection.left:
        direction = TooltipDirection.left;
        break;
    }

    return MouseRegion(
      onEnter: (event) {
        _showTimer = Timer(const Duration(milliseconds: 1200), () {
          _show = true;

          if (mounted) {
            setState(() {});
          }
        });
      },
      onExit: (event) {
        _showTimer?.cancel();

        _show = false;
        if (mounted) {
          setState(() {});
        }
      },
      child: SimpleTooltip(
        // arrowLength: 30,
        // arrowTipDistance: 10,
        ballonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        backgroundColor: Colors.black87,
        borderColor: Colors.black54,
        animationDuration: const Duration(milliseconds: 300),
        show: _show,
        tooltipDirection: direction,
        content: Text(
          msg,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            decoration: TextDecoration.none,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
