import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    this.leading,
    this.trailing,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subWidget,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.color,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.maxSubtitleLines = 2,
    this.disableHoverColor = false,
  });

  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? titleWidget;
  final Widget? subWidget;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final int maxSubtitleLines;
  final bool disableHoverColor;

  static Color? backgroundForIndex({
    required int index,
    required bool darkMode,
  }) {
    final c = darkMode
        ? Colors.white.withValues(alpha: 0.02)
        : Colors.black.withValues(alpha: 0.01);

    return index.isEven ? c : null;
  }

  @override
  Widget build(BuildContext context) {
    final titleChildren = <Widget>[];

    if (titleWidget != null) {
      titleChildren.add(titleWidget!);
    }

    if (Utils.isNotEmpty(title)) {
      titleChildren.add(
        Text(
          title!,
          overflow: TextOverflow.ellipsis,
          softWrap: false, // keeps title on one line
          style: titleStyle ?? Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    // space between title and subtitle
    if (subWidget != null || Utils.isNotEmpty(subtitle)) {
      titleChildren.add(const SizedBox(height: 2));
    }

    if (Utils.isNotEmpty(subtitle)) {
      titleChildren.add(
        Text(
          subtitle!,
          overflow: TextOverflow.ellipsis,
          softWrap: false, // keeps title on one line
          style: subtitleStyle ?? Theme.of(context).textTheme.bodyMedium,
          maxLines: maxSubtitleLines,
        ),
      );
    }

    if (subWidget != null) {
      titleChildren.add(subWidget!);
    }

    final rowChildren = <Widget>[];

    if (leading != null) {
      rowChildren.add(leading!);
      rowChildren.add(const SizedBox(width: 14));
    }

    rowChildren.addAll([
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: titleChildren,
        ),
      ),
    ]);

    if (trailing != null) {
      rowChildren.add(trailing!);
    }

    return Ink(
      color: color,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        hoverColor: disableHoverColor ? Colors.transparent : null,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}
