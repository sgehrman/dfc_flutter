import 'package:flutter/material.dart';

// use this so all our menus are the same heights (default is too big)
PopupMenuEntry<T> popupMenuItem<T>({
  required Widget? child, // null for PopupMenuDivider
  required T value,
  bool enabled = true,
}) {
  if (child == null) {
    return const PopupMenuDivider();
  }

  return PopupMenuItem<T>(
    value: value,
    height: kMinInteractiveDimension - 8,
    enabled: enabled,
    child: child,
  );
}

CheckedPopupMenuItem<T> checkedPopupMenuItem<T>({
  required Widget child,
  required T value,
  required bool checked,
  bool enabled = true,
}) {
  return CheckedPopupMenuItem<T>(
    value: value,
    checked: checked,
    height: kMinInteractiveDimension - 8,
    enabled: enabled,
    child: child,
  );
}
