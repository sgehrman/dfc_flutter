import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme_notifier.dart';
import 'package:flutter/material.dart';

class XpandableController extends ValueNotifier<bool> {
  XpandableController({
    bool? initialExpanded,
  }) : super(initialExpanded ?? false);

  bool get expanded => value;

  set expanded(bool exp) {
    value = exp;
  }

  void toggle() {
    expanded = !expanded;
  }

  static XpandableController? of(
    BuildContext context, {
    bool rebuildOnChange = true,
  }) {
    final notifier = rebuildOnChange
        ? context
            .dependOnInheritedWidgetOfExactType<XpandableControllerNotifier>()
        : context.findAncestorWidgetOfExactType<XpandableControllerNotifier>();

    return notifier?.notifier;
  }
}

class Xpandable extends StatelessWidget {
  const Xpandable({
    required XpandableThemeData theme,
    super.key,
    this.collapsed,
    this.expanded,
    this.controller,
  }) : _theme = theme;

  final Widget? collapsed;
  final Widget? expanded;
  final XpandableController? controller;

  final XpandableThemeData _theme;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? XpandableController.of(context)!;
    final theme = XpandableThemeData.withDefaults(_theme);

    return AnimatedCrossFade(
      alignment: theme.alignment!,
      firstChild: collapsed ?? Container(),
      secondChild: expanded ?? Container(),
      firstCurve: Interval(
        theme.collapsedFadeStart,
        theme.collapsedFadeEnd,
        curve: theme.fadeCurve!,
      ),
      secondCurve: Interval(
        theme.expandedFadeStart,
        theme.expandedFadeEnd,
        curve: theme.fadeCurve!,
      ),
      sizeCurve: theme.sizeCurve!,
      crossFadeState: controller.expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: theme.animationDuration!,
    );
  }
}
