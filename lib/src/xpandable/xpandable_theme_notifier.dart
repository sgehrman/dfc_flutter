import 'package:dfc_flutter/src/xpandable/xpandable_controller.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:flutter/material.dart';

class XpandableNotifier extends StatefulWidget {
  const XpandableNotifier({
    required this.controller,
    required this.child,
    super.key,
  });

  final XpandableController? controller;
  final Widget child;

  @override
  State<XpandableNotifier> createState() => _XpandableNotifierState();
}

class _XpandableNotifierState extends State<XpandableNotifier> {
  XpandableThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final cn = XpandableControllerNotifier(
      controller: widget.controller,
      child: widget.child,
    );

    return theme != null
        ? XpandableThemeNotifier(themeData: theme, child: cn)
        : cn;
  }
}

class XpandableControllerNotifier
    extends InheritedNotifier<XpandableController> {
  const XpandableControllerNotifier({
    required XpandableController? controller,
    required super.child,
  }) : super(notifier: controller);
}

class XpandableThemeNotifier extends InheritedWidget {
  const XpandableThemeNotifier({
    required this.themeData,
    required super.child,
  });

  final XpandableThemeData? themeData;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return !(oldWidget is XpandableThemeNotifier &&
        oldWidget.themeData == themeData);
  }
}
