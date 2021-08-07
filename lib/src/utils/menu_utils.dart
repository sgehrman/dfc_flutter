import 'package:flutter/material.dart';

class MenuUtils {
  static void displayMenu<T>({
    required BuildContext context,
    required Offset globalPosition,
    required Function(T value) onChange,
    required List<PopupMenuEntry<T>> menuItems,
  }) {
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

      showMenu<T>(
        context: context,
        elevation: popupMenuTheme.elevation,
        items: menuItems,
        position: position,
        shape: popupMenuTheme.shape,
        color: popupMenuTheme.color,
      ).then<void>((T? newValue) {
        if (newValue == null) {
          return null;
        }

        onChange(newValue);
      });
    }
  }
}
