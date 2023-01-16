import 'package:dfc_flutter/src/utils/menu.dart';
import 'package:flutter/material.dart';

class MenuUtils {
  static Future<T?> displayMenu<T>({
    required BuildContext context,
    required Offset localPosition,
    required List<PopupMenuEntry<T>> menuItems,
  }) async {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox? overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox?;

    if (button != null && overlay != null) {
      final buttonRect = Rect.fromPoints(
        button.localToGlobal(
          localPosition,
          ancestor: overlay,
        ),
        button.localToGlobal(
          localPosition + const Offset(10, 10),
          ancestor: overlay,
        ),
      );

      final RelativeRect position = RelativeRect.fromRect(
        buttonRect,
        Offset.zero & overlay.size,
      );

      return showMenuu<T>(
        context: context,
        elevation: popupMenuTheme.elevation,
        items: menuItems,
        position: position,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
      );
    }

    return null;
  }
}

// use this so all our menus are the same heights (default is too big)
PopupMenuItem<T> popupMenuItem<T>({
  required Widget child,
  required T value,
  bool enabled = true,
}) {
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
