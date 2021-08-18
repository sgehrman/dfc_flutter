import 'dart:async';

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

class HelpTip extends StatefulWidget {
  const HelpTip({
    required this.message,
    required this.child,
    this.side = TooltipDirection.down,
  });

  final String message;
  final Widget child;
  final TooltipDirection side;

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

    return MouseRegion(
      onEnter: (event) {
        _showTimer = Timer(const Duration(milliseconds: 800), () {
          _show = true;

          setState(() {});
        });
      },
      onExit: (event) {
        _showTimer?.cancel();

        _show = false;
        setState(() {});
      },
      child: _show
          ? SimpleTooltip(
              // arrowLength: 30,
              // arrowTipDistance: 10,
              ballonPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              backgroundColor: Colors.black87,
              borderColor: Colors.black54,
              animationDuration: const Duration(milliseconds: 300),
              show: _show,
              tooltipDirection: widget.side,
              content: Text(
                msg,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
              child: widget.child,
            )
          : widget.child,
    );
  }
}
