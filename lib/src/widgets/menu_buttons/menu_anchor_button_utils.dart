import 'package:dfc_flutter/src/widgets/triangle_painter.dart';
import 'package:flutter/material.dart';

class MenuAnchorButtonContents extends StatelessWidget {
  const MenuAnchorButtonContents({
    required this.controller,
    // one must be set
    this.icon,
    this.title,
    this.widget,
    // all bellow, only used for icons
    this.tooltip,
    this.color,
    this.filledButton = false,
    this.small = false,
  });

  final MenuController controller;
  final Widget? icon;
  final String? title;
  final String? tooltip;
  final Color? color;
  final Widget? widget;
  final bool filledButton;
  final bool small;

  void _onPressed(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return TextButton.icon(
        iconAlignment: IconAlignment.end,
        onPressed: () => _onPressed(controller),
        label: Text(title!),
        icon: TrianglePainter.downArrowIcon(
          context: context,
          padding: const EdgeInsets.only(left: 4, top: 4),
          height: 7,
          width: 11,
        ),
      );
    }

    if (icon != null) {
      if (filledButton) {
        return IconButton.filled(
          iconSize: small ? 20 : null,
          color: color,
          onPressed: () => _onPressed(controller),
          icon: icon!,
          tooltip: tooltip,
        );
      } else {
        return IconButton(
          iconSize: small ? 20 : null,
          color: color,
          onPressed: () => _onPressed(controller),
          icon: icon!,
          tooltip: tooltip,
        );
      }
    }

    if (widget != null) {
      return InkWell(
        onTap: () => _onPressed(controller),
        child: widget,
      );
    }

    return const Text('icon/title/wiget null');
  }
}
