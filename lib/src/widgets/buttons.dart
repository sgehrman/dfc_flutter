import 'package:dfc_flutter/src/widgets/df_tool_tip/df_tooltip.dart';
import 'package:flutter/material.dart';

// DFIconButton in a textfields prefix/suffix icons
// use this with small: true,
// prefixIconConstraints: DFIconButton.kIconConstraints,
// suffixIconConstraints: DFIconButton.kIconConstraints,

class DFIconButton extends StatelessWidget {
  const DFIconButton({
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.iconSize,
    this.color,
    this.small = false,
    super.key,
  });

  static const double kSmallSize = 32;
  static const kIconConstraints = BoxConstraints(
    minWidth: kSmallSize,
    maxWidth: kSmallSize,
    minHeight: kSmallSize,
    maxHeight: kSmallSize,
  );

  final Function()? onPressed;
  final Widget icon;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final result = IconButton(
      focusNode: FocusNode(skipTraversal: true),
      iconSize: iconSize,
      color: color,
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
    );

    if (small) {
      return SizedBox(
        height: kSmallSize,
        width: kSmallSize,
        child: FittedBox(
          child: result,
        ),
      );
    }

    return result;
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

    return DFTooltip(
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

    return DFTooltip(
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

    return DFTooltip(
      message: tooltip,
      child: b,
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
