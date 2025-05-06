import 'package:dfc_flutter/src/xpandable/xpandable_theme_notifier.dart';
import 'package:flutter/material.dart';

class XpandableThemeData {
  const XpandableThemeData({
    required this.expandIcon,
    this.animationDuration,
    this.scrollAnimationDuration,
    this.crossFadePoint,
    this.fadeCurve,
    this.sizeCurve,
    this.alignment,
    this.hoverColor,
    this.headerDecoration,
  });

  factory XpandableThemeData.combine(
    XpandableThemeData theme,
    XpandableThemeData defaults,
  ) {
    if (theme.isFull()) {
      return theme;
    } else {
      return XpandableThemeData(
        animationDuration:
            theme.animationDuration ?? defaults.animationDuration,
        scrollAnimationDuration:
            theme.scrollAnimationDuration ?? defaults.scrollAnimationDuration,
        crossFadePoint: theme.crossFadePoint ?? defaults.crossFadePoint,
        fadeCurve: theme.fadeCurve ?? defaults.fadeCurve,
        sizeCurve: theme.sizeCurve ?? defaults.sizeCurve,
        alignment: theme.alignment ?? defaults.alignment,
        hoverColor: theme.hoverColor ?? defaults.hoverColor,
        expandIcon: theme.expandIcon,
        headerDecoration: theme.headerDecoration ?? defaults.headerDecoration,
      );
    }
  }

  factory XpandableThemeData.withDefaults(XpandableThemeData theme) {
    if (theme.isFull()) {
      return theme;
    } else {
      return XpandableThemeData.combine(theme, defaults);
    }
  }
  static const XpandableThemeData defaults = XpandableThemeData(
    animationDuration: Duration(milliseconds: 300),
    scrollAnimationDuration: Duration(milliseconds: 300),
    crossFadePoint: 0.5,
    fadeCurve: Curves.linear,
    sizeCurve: Curves.fastOutSlowIn,
    alignment: Alignment.topLeft,
    expandIcon: Icon(Icons.chevron_right),
    headerDecoration: BoxDecoration(color: Colors.transparent),
  );

  final Duration? animationDuration;
  final Duration? scrollAnimationDuration;
  final double? crossFadePoint;
  final AlignmentGeometry? alignment;
  final Curve? fadeCurve;
  final Curve? sizeCurve;
  final Color? hoverColor;
  final BoxDecoration? headerDecoration;
  final Widget expandIcon;

  double get collapsedFadeStart =>
      crossFadePoint! < 0.5 ? 0 : (crossFadePoint! * 2 - 1);

  double get collapsedFadeEnd =>
      crossFadePoint! < 0.5 ? 2 * crossFadePoint! : 1;

  double get expandedFadeStart =>
      crossFadePoint! < 0.5 ? 0 : (crossFadePoint! * 2 - 1);

  double get expandedFadeEnd => crossFadePoint! < 0.5 ? 2 * crossFadePoint! : 1;

  bool isFull() {
    return animationDuration != null &&
        scrollAnimationDuration != null &&
        crossFadePoint != null &&
        fadeCurve != null &&
        sizeCurve != null &&
        alignment != null &&
        hoverColor != null &&
        headerDecoration != null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is XpandableThemeData) {
      return animationDuration == other.animationDuration &&
          scrollAnimationDuration == other.scrollAnimationDuration &&
          crossFadePoint == other.crossFadePoint &&
          fadeCurve == other.fadeCurve &&
          sizeCurve == other.sizeCurve &&
          alignment == other.alignment &&
          hoverColor == other.hoverColor &&
          expandIcon == other.expandIcon &&
          headerDecoration == other.headerDecoration;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return 0;
  }

  static XpandableThemeData of(
    BuildContext context, {
    bool rebuildOnChange = true,
  }) {
    final notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<XpandableThemeNotifier>()
        : context.findAncestorWidgetOfExactType<XpandableThemeNotifier>();

    return notifier?.themeData ?? defaults;
  }
}

class XpandableTheme extends StatelessWidget {
  const XpandableTheme({required this.data, required this.child});
  final XpandableThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final n =
        context.dependOnInheritedWidgetOfExactType<XpandableThemeNotifier>();

    return XpandableThemeNotifier(
      themeData: XpandableThemeData.combine(data, n!.themeData!),
      child: child,
    );
  }
}
