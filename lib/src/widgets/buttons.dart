import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';

class DFIconButton extends StatelessWidget {
  const DFIconButton({
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.iconSize,
    this.color,
    this.tooltipDirection,
    this.disableHighlightColors = false,
    Key? key,
  }) : super(key: key);

  final Function()? onPressed;
  final Widget icon;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final AxisDirection? tooltipDirection;
  final bool disableHighlightColors;

  @override
  Widget build(BuildContext context) {
    return HelpTip(
      message: tooltip,
      direction: tooltipDirection ?? AxisDirection.down,
      child: IconButton(
        splashColor: disableHighlightColors ? Colors.transparent : null,
        highlightColor: disableHighlightColors ? Colors.transparent : null,
        hoverColor: disableHighlightColors ? Colors.transparent : null,
        iconSize: iconSize ?? IconTheme.of(context).size ?? 24.0,
        color: color, // null is default
        onPressed: onPressed,
        splashRadius: 24,
        icon: icon,
      ),
    );
  }
}

// ===================================================================

class DFTextButton extends StatelessWidget {
  const DFTextButton({
    required this.onPressed,
    required this.label,
    this.tooltip,
    this.icon,
    Key? key,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;
  final String? tooltip;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (icon != null) {
      b = TextButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: icon!,
      );
    } else {
      b = TextButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return HelpTip(
      message: tooltip,
      child: b,
    );
  }
}

// ===================================================================

class DFButton extends StatelessWidget {
  const DFButton({
    required this.onPressed,
    required this.label,
    this.tooltip,
    this.secondary = false,
    this.color,
    this.icon,
    Key? key,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;
  final bool secondary;
  final Color? color;
  final String? tooltip;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (icon != null) {
      b = ElevatedButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: icon!,
        style: secondary
            ? ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )
            : null,
      );
    } else {
      b = ElevatedButton(
        onPressed: onPressed,
        style: secondary
            ? ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )
            : null,
        child: Text(label),
      );
    }

    return HelpTip(
      message: tooltip,
      child: b,
    );
  }
}

// ===================================================================

class DFOutlineButton extends StatelessWidget {
  const DFOutlineButton({
    required this.onPressed,
    required this.label,
    this.tooltip,
    this.color,
    this.icon,
    Key? key,
  }) : super(key: key);

  final Function()? onPressed;
  final String label;
  final Color? color;
  final String? tooltip;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (icon != null) {
      b = OutlinedButton.icon(
        onPressed: onPressed,
        label: Text(label),
        icon: icon!,
      );
    } else {
      b = OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return HelpTip(
      message: tooltip,
      child: b,
    );
  }
}

// =================================================================

class IconMenuButton extends StatelessWidget {
  const IconMenuButton({
    required this.menuItems,
    this.iconData,
    this.color,
    Key? key,
  }) : super(key: key);

  final List<MenuItemData> menuItems;
  final Color? color;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return DFIconButton(
      onPressed: () {
        showContextMenu(
          localPosition: Offset(0, context.size?.height ?? 0),
          context: context,
          menuData: menuItems,
          large: true,
        );
      },
      icon: const Icon(Icons.more_vert),
    );
  }
}
