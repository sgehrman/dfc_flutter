import 'package:dfc_flutter/src/preferences/preferences.dart';
import 'package:dfc_flutter/src/widgets/help_tip.dart';
import 'package:flutter/material.dart';

// like Tooltip, but handles html tips
class ToolTip extends StatelessWidget {
  const ToolTip({
    required this.child,
    required this.message,
    this.waitDuration,
    super.key,
  });

  final Widget child;
  final String message;
  final Duration? waitDuration;

  @override
  Widget build(BuildContext context) {
    if (Preferences().disableTooltips || message.isEmpty) {
      return child;
    }

    final WidgetSpan tooltipWidget = WidgetSpan(
      child: HelpTipContent(
        message: message,
        maxWidth: 600,
      ),
    );

    return Tooltip(
      richMessage: tooltipWidget,
      waitDuration: waitDuration, // rarely customized, usually null
      child: child,
    );
  }
}
