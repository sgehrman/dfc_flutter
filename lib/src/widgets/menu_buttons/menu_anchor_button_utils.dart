import 'package:dfc_flutter/src/widgets/triangle_painter.dart';
import 'package:flutter/material.dart';

class MenuAnchorButtonText extends StatelessWidget {
  const MenuAnchorButtonText(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        TrianglePainter.downArrowIcon(
          context: context,
          padding: const EdgeInsets.only(left: 4, top: 4),
          height: 7,
          width: 11,
        ),
      ],
    );
  }
}

// ========================================================

class MenuAnchorButtonContents extends StatelessWidget {
  const MenuAnchorButtonContents({
    required this.controller,
    // one must be set
    this.icon,
    this.title,
    this.widget,
    // tooltip only used for icons
    this.tooltip,
    this.color,
  });

  final MenuController controller;
  final Widget? icon;
  final String? title;
  final String? tooltip;
  final Color? color;
  final Widget? widget;

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
      return TextButton(
        onPressed: () => _onPressed(controller),
        child: MenuAnchorButtonText(title!),
      );
    }

    if (icon != null) {
      return IconButton(
        color: color,
        onPressed: () => _onPressed(controller),
        icon: icon!,
        tooltip: tooltip,
      );
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
