import 'package:flutter/material.dart';

class MenuUtils {
  static Future<T?> displayMenu<T>({
    required BuildContext context,
    required Offset globalPosition,
    required List<PopupMenuEntry<T>> menuItems,
  }) async {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    const Offset widgetOffset = Offset(0, 32);
    final RenderBox? overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox?;

    if (button != null && overlay != null) {
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          globalPosition,
          // button.localToGlobal(widgetOffset, ancestor: overlay),
          button.localToGlobal(
              button.size.bottomRight(Offset.zero) + widgetOffset,
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );

      final result = await showMenu<T>(
        context: context,
        elevation: popupMenuTheme.elevation,
        items: menuItems,
        position: position,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
      );

      return result;
    }

    return null;
  }
}
