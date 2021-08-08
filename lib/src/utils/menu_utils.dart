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
