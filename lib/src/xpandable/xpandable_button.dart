import 'package:dfc_flutter/src/xpandable/xpandable_controller.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:flutter/material.dart';

class XpandableButton extends StatelessWidget {
  const XpandableButton({
    required this.child,
    this.theme,
  });

  final Widget? child;
  final XpandableThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final controller = XpandableController.of(context);

    return InkWell(
      onTap: controller!.toggle,
      hoverColor: theme?.hoverColor,
      child: child,
    );
  }
}
