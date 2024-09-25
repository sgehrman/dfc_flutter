import 'package:dfc_flutter/src/xpandable/xpandable_controller.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:flutter/material.dart';

class XpandableIcon extends StatefulWidget {
  const XpandableIcon({
    required XpandableThemeData theme,
  }) : _theme = theme;

  final XpandableThemeData _theme;

  @override
  State<XpandableIcon> createState() => _XpandableIconState();
}

class _XpandableIconState extends State<XpandableIcon> {
  XpandableThemeData? theme;
  late XpandableController controller;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    controller = XpandableController.of(context, rebuildOnChange: false)!;
    controller.addListener(_expandedStateChanged);

    _expanded = controller.expanded;
  }

  @override
  void dispose() {
    controller.removeListener(_expandedStateChanged);
    super.dispose();
  }

  void _expandedStateChanged() {
    _expanded = controller.expanded;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    theme ??= XpandableThemeData.withDefaults(widget._theme);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedRotation(
        turns: _expanded ? 0.25 : 0,
        duration: theme!.animationDuration!,
        child: theme!.expandIcon,
      ),
    );
  }
}
