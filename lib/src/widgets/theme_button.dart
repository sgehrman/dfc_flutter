import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    this.title,
    required this.onPressed,
    this.icon,
    this.disabled = false,
    this.padding,
    this.fontSize,
  });

  final String? title;
  final void Function() onPressed;
  final Icon? icon;
  final bool disabled;
  final double? fontSize;
  final EdgeInsets? padding;

  Widget buttonLabel() {
    return Text(
      title!,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Theme.of(context).primaryColor;

    final ThemeSet? themeSet = ThemeSetManager().currentTheme;

    Color? textColor;
    if (themeSet != null) {
      textColor = themeSet.buttonContentColor;
    }

    disabledColor = Utils.lighten(disabledColor);

    if (icon != null) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          primary: textColor ?? Colors.white,
          padding: padding,
        ),
        onPressed: disabled ? null : onPressed,
        label: buttonLabel(),
        icon: icon!,
      );
    }
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        primary: textColor ?? Colors.white,
        padding: padding,
      ),
      onPressed: disabled ? null : onPressed,
      child: buttonLabel(),
    );
  }
}
