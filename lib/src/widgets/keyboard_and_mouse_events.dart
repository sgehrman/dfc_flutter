import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardAndMouseEvents extends StatelessWidget {
  const KeyboardAndMouseEvents({
    required this.child,
    this.focusNode,
    this.onEscCallback,
    this.onTabCallback,
    this.onShiftTabCallback,
    this.onEnterCallback,
    this.onHoverCallback,
    this.onArrowUpCallback,
    this.onArrowDownCallback,
  });

  final void Function()? onEscCallback;
  final void Function()? onTabCallback;
  final void Function()? onShiftTabCallback;
  final void Function()? onEnterCallback;
  final void Function()? onArrowUpCallback;
  final void Function()? onArrowDownCallback;
  final ValueChanged<bool>? onHoverCallback;
  final Widget child;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
        actions: _initActions(),
        shortcuts: _initShortcuts(),
        onShowHoverHighlight: onHoverCallback,
        focusNode: focusNode,
        child: child,
      );

  Map<LogicalKeySet, Intent> _initShortcuts() => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.escape): const _XIntent.esc(),
        LogicalKeySet(LogicalKeyboardKey.tab): const _XIntent.tab(),
        LogicalKeySet.fromSet(
          {LogicalKeyboardKey.tab, LogicalKeyboardKey.shift},
        ): const _XIntent.shiftTab(),
        LogicalKeySet(LogicalKeyboardKey.enter): const _XIntent.enter(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const _XIntent.arrowUp(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const _XIntent.arrowDown(),
      };

  void _actionHandler(_XIntent intent) {
    switch (intent.type) {
      case _XIntentType.esc:
        onEscCallback?.call();
        break;
      case _XIntentType.tab:
        onTabCallback?.call();
        break;
      case _XIntentType.shifTab:
        onShiftTabCallback?.call();
        break;
      case _XIntentType.enter:
        onEnterCallback?.call();
        break;
      case _XIntentType.arrowUp:
        onArrowUpCallback?.call();
        break;
      case _XIntentType.arrowDown:
        onArrowDownCallback?.call();
        break;
    }
  }

  Map<Type, Action<Intent>> _initActions() {
    return <Type, Action<Intent>>{
      _XIntent: CallbackAction<_XIntent>(
        onInvoke: _actionHandler,
      ),
    };
  }
}

class _XIntent extends Intent {
  const _XIntent({required this.type});

  const _XIntent.esc() : type = _XIntentType.esc;
  const _XIntent.tab() : type = _XIntentType.tab;
  const _XIntent.shiftTab() : type = _XIntentType.shifTab;
  const _XIntent.enter() : type = _XIntentType.enter;
  const _XIntent.arrowUp() : type = _XIntentType.arrowUp;
  const _XIntent.arrowDown() : type = _XIntentType.arrowDown;

  final _XIntentType type;
}

enum _XIntentType {
  esc,
  tab,
  shifTab,
  enter,
  arrowUp,
  arrowDown,
}
