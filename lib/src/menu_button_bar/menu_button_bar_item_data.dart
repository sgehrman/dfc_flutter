import 'package:flutter/material.dart';

class MenuButtonBarItemData {
  MenuButtonBarItemData({
    this.title,
    this.leading,
    this.trailing,
    this.action,
    this.enabled = true,
    this.selected = false,
    this.tooltip = '',
    this.children = const [],
  }) : divider = false;

  MenuButtonBarItemData._divider()
      : title = null,
        leading = null,
        trailing = null,
        tooltip = '',
        divider = true,
        selected = false,
        enabled = true,
        children = [],
        action = null;

  factory MenuButtonBarItemData.divider() {
    return MenuButtonBarItemData._divider();
  }

  // convert older MenuItemData to MenuButtonBarItemData
  factory MenuButtonBarItemData.from(MenuItemData itemData) {
    if (itemData.title.isEmpty) {
      return MenuButtonBarItemData.divider();
    }

    Widget? leading = itemData.iconWidget;
    if (itemData.iconData != null) {
      leading = Icon(itemData.iconData);
    }

    return MenuButtonBarItemData(
      title: itemData.title,
      leading: leading,
      tooltip: itemData.tooltip ?? '',
      action: itemData.action,
      enabled: itemData.enabled,
    );
  }

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final bool divider;
  final bool enabled;
  final bool selected;
  final String tooltip;
  final void Function()? action;
  List<MenuButtonBarItemData> children;

  static Widget get leadingSpace => const Icon(
        Icons.check,
        color: Colors.transparent,
      );

  // convert older List<MenuItemData> to List<MenuButtonBarItemData>
  static List<MenuButtonBarItemData> fromMenuItems(List<MenuItemData> items) {
    return items.map((e) => MenuButtonBarItemData.from(e)).toList();
  }
}

// =================================================================
// obsolete

class MenuItemData {
  MenuItemData({
    required this.title,
    this.iconData,
    this.iconWidget,
    this.action,
    this.enabled = true,
    this.tooltip,
  });
  MenuItemData._divider()
      : title = '',
        iconData = null,
        iconWidget = null,
        tooltip = null,
        enabled = false,
        action = null;

  factory MenuItemData.divider() {
    return MenuItemData._divider();
  }

  final String title;
  final IconData? iconData;
  final Widget? iconWidget;
  final bool enabled;
  final String? tooltip;
  final void Function()? action;
}
