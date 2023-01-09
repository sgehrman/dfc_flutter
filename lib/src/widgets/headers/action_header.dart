import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

class ActionHeader extends StatelessWidget {
  const ActionHeader({
    this.title,
    this.onTap,
    this.iconData,
    this.top = 0,
    this.bottom = 0,
    this.textStyle,
    this.iconSize = 24,
    this.upperCase = true,
    this.subtitle,
    this.subWidget,
    this.action,
  });

  final String? title;
  final IconData? iconData;
  final void Function()? onTap;
  final double top;
  final double bottom;
  final TextStyle? textStyle;
  final double iconSize;
  final bool upperCase;
  final String? subtitle;
  final Widget? action;
  final Widget? subWidget;

  TextStyle? _textStyle(BuildContext context) {
    if (textStyle != null) {
      return textStyle;
    }

    return ActionHeader.defaultTextStyle(context);
  }

  static TextStyle? defaultTextStyle(BuildContext context) {
    return ThemeSetManager.header(context);
  }

  static TextStyle? defaultSubtitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall;
  }

  @override
  Widget build(BuildContext context) {
    Widget? subtitleWidget = const NothingWidget();

    if (subWidget != null) {
      subtitleWidget = subWidget;
    } else if (Utils.isNotEmpty(subtitle)) {
      subtitleWidget = ExpandableText(
        subtitle,
        style: defaultSubtitleStyle(context),
        maxLength: 220,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottom, top: top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // padding makes it align with icon
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    upperCase ? title!.toUpperCase() : title!,
                    style: _textStyle(context),
                  ),
                ),
                subtitleWidget!,
              ],
            ),
          ),
          if (iconData != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.loose(const Size(32, 32)),
              iconSize: iconSize,
              // icon: Icon(iconData, color: _textStyle(context).color),
              icon: Icon(
                iconData,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: onTap,
            ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
