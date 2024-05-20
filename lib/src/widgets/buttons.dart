import 'package:dfc_flutter/src/widgets/context_menu_area.dart';
import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:flutter/material.dart';

class DFIconButton extends StatelessWidget {
  const DFIconButton({
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.iconSize,
    this.color,
    this.disableHighlightColors = false,
    super.key,
  });

  final Function()? onPressed;
  final Widget icon;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final bool disableHighlightColors;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusNode: FocusNode(skipTraversal: true),
      splashColor: disableHighlightColors ? Colors.transparent : null,
      highlightColor: disableHighlightColors ? Colors.transparent : null,
      hoverColor: disableHighlightColors ? Colors.transparent : null,
      iconSize: iconSize ?? IconTheme.of(context).size ?? 24.0,
      color: color, // null is default
      onPressed: onPressed,
      splashRadius: 24,
      icon: icon,
      tooltip: tooltip,
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
    this.color,
    super.key,
  });

  final Function()? onPressed;
  final String label;
  final String? tooltip;
  final Widget? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (icon != null) {
      b = TextButton.icon(
        focusNode: FocusNode(skipTraversal: true),
        onPressed: onPressed,
        label: _ButtonText(label, color: color),
        icon: icon,
      );
    } else {
      b = TextButton(
        focusNode: FocusNode(skipTraversal: true),
        onPressed: onPressed,
        child: _ButtonText(label, color: color),
      );
    }

    return ToolTip(
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
    this.icon,
    this.filled = true,
    super.key,
  });

  final Function()? onPressed;
  final String label;
  final String? tooltip;
  final Widget? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (filled) {
      if (icon != null) {
        b = FilledButton.icon(
          focusNode: FocusNode(skipTraversal: true),
          onPressed: onPressed,
          label: _ButtonText(label),
          icon: icon,
        );
      } else {
        b = FilledButton(
          focusNode: FocusNode(skipTraversal: true),
          onPressed: onPressed,
          child: _ButtonText(label),
        );
      }
    } else {
      if (icon != null) {
        b = ElevatedButton.icon(
          focusNode: FocusNode(skipTraversal: true),
          onPressed: onPressed,
          label: _ButtonText(label),
          icon: icon,
        );
      } else {
        b = ElevatedButton(
          focusNode: FocusNode(skipTraversal: true),
          onPressed: onPressed,
          child: _ButtonText(label),
        );
      }
    }

    return ToolTip(
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
    this.icon,
    super.key,
  });

  final Function()? onPressed;
  final String label;
  final String? tooltip;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    Widget b;

    if (icon != null) {
      b = OutlinedButton.icon(
        focusNode: FocusNode(skipTraversal: true),
        onPressed: onPressed,
        label: _ButtonText(label),
        icon: icon,
      );
    } else {
      b = OutlinedButton(
        focusNode: FocusNode(skipTraversal: true),
        onPressed: onPressed,
        child: _ButtonText(label),
      );
    }

    return ToolTip(
      message: tooltip,
      child: b,
    );
  }
}

// =================================================================

class DFIconMenuButton extends StatelessWidget {
  const DFIconMenuButton({
    required this.itemBuilder,
    this.iconData,
    this.iconSize,
    this.icon,
    this.color,
    super.key,
  });

  final List<MenuItemData> Function() itemBuilder;
  final Color? color;
  final IconData? iconData;
  final Widget? icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return DFIconButton(
      onPressed: () {
        showContextMenu(
          localPosition: Offset(0, context.size?.height ?? 0),
          context: context,
          menuData: itemBuilder(),
        );
      },
      color: color,
      iconSize: iconSize,
      icon: icon ?? Icon(iconData ?? Icons.more_vert),
    );
  }
}

// ===========================================================

class _ButtonText extends StatelessWidget {
  const _ButtonText(
    this.text, {
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: color != null ? TextStyle(color: color) : null,
    );
  }
}
