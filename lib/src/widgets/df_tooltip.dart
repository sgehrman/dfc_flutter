import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// same as Tooltip, but handles null messages without exceptions
// it also wraps text so the tooltip isn't so wide

class DFTooltip extends StatelessWidget {
  const DFTooltip({
    required this.message,
    required this.child,
    this.preferBelow,
  });

  final String? message;
  final Widget child;
  final bool? preferBelow;

  String _wrapString(String? message) {
    if (Utils.isNotEmpty(message)) {
      final words = message!.split(' ');

      final buffer = StringBuffer();

      int letterCnt = 0;
      for (final word in words) {
        letterCnt += word.length;
        buffer.write('$word ');

        if (letterCnt > 40) {
          letterCnt = 0;
          buffer.write('\n');
        }
      }

      return buffer.toString().trim();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final msg = _wrapString(message);

    if (msg.isNotEmpty) {
      return Listener(
        onPointerSignal: (event) {
          print(event);

          if (event is PointerScrollEvent) {
            print('is pointer');

            GestureBinding.instance.pointerSignalResolver.register(event,
                (PointerSignalEvent e) {
              if (e is PointerScrollEvent) {
                Scrollable.of(context).position.jumpTo(
                      Scrollable.of(context).position.pixels + e.scrollDelta.dy,
                    );
              }
            });
          }
        },
        child: Tooltip(
          message: msg,
          preferBelow: preferBelow,
          enableTapToDismiss: false,
          enableFeedback: false,
          child: child,
        ),
      );
    }

    return child;
  }
}
