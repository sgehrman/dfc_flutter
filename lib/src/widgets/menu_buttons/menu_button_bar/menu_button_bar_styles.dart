import 'package:flutter/material.dart';

class MenuButtonBarStyles {
  static MenuStyle transparentMenuBarStyle(BuildContext context) {
    return MenuStyle(
      elevation: WidgetStateProperty.resolveWith<double>(
        (states) => 0,
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          return Colors.transparent;
        },
      ),
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
        (states) {
          return EdgeInsets.zero;
        },
      ),
    );
  }

  static MenuStyle menuBarStyle(BuildContext context) {
    return MenuStyle(
      elevation: WidgetStateProperty.resolveWith<double>(
        (states) => 2,
      ),
      shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
        (states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          );
        },
      ),
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
        (states) {
          return const EdgeInsets.symmetric(horizontal: 12);
        },
      ),
    );
  }

  static ButtonStyle menuBarItemStyle({
    required BuildContext context,
    required bool round,
  }) {
    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith<double>(
        (states) => 0,
      ),
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
        if (round) {
          return const CircleBorder();
        }

        return const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        );
      }),
      iconSize: WidgetStateProperty.resolveWith((states) => 24),
      minimumSize: WidgetStateProperty.resolveWith((states) => Size.zero),
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>((states) {
        if (round) {
          // 16 seems to match the size of a DFIconButton, so if change
          // make sure they match, see PanelToolbar top padding
          return const EdgeInsets.symmetric(horizontal: 6, vertical: 16);
        }

        return const EdgeInsets.symmetric(horizontal: 10, vertical: 16);
      }),
    );
  }
}
