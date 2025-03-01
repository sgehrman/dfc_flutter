import 'package:dfc_flutter/src/extensions/color_ext.dart';
import 'package:dfc_flutter/src/themes/theme_utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

class ButtonThemes {
  ButtonThemes({
    required this.baseTheme,
    this.boldButtons,
    this.buttonFontSize,
    this.whiteButtons = false,
  });

  final ThemeData baseTheme;
  bool? boldButtons;
  double? buttonFontSize;
  bool whiteButtons; // text and filled

  ElevatedButtonThemeData elevatedButtonTheme() {
    final startTheme = baseTheme.elevatedButtonTheme;

    final backColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _backColor(states),
    );

    final padding = WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
      (states) => _buttonPadding(states),
    );

    final foregroundColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _buttonTextColor(states: states, filledButton: true),
    );

    final textStyle = WidgetStateProperty.resolveWith<TextStyle>(
      (states) => _buttonTextStyle(states: states),
    );

    final minSize = WidgetStateProperty.resolveWith<Size>(
      (states) => _buttonMinSize(),
    );

    final iconSize = WidgetStateProperty.resolveWith<double>(
      (states) => _buttonIconSize(),
    );

    final ButtonStyle startStyle = startTheme.style ?? const ButtonStyle();
    final ButtonStyle style = startStyle.copyWith(
      textStyle: textStyle,
      backgroundColor: backColor,
      iconColor: foregroundColor,
      foregroundColor: foregroundColor,
      shape: _buttonShape(),
      minimumSize: minSize,
      padding: padding,
      iconSize: iconSize,
    );

    return ElevatedButtonThemeData(style: style);
  }

  FilledButtonThemeData filledButtonTheme() {
    final startTheme = baseTheme.filledButtonTheme;

    final backColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _backColor(states),
    );

    final padding = WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
      (states) => _buttonPadding(states),
    );

    final foregroundColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _buttonTextColor(states: states, filledButton: true),
    );

    final textStyle = WidgetStateProperty.resolveWith<TextStyle>(
      (states) => _buttonTextStyle(states: states),
    );

    final minSize = WidgetStateProperty.resolveWith<Size>(
      (states) => _buttonMinSize(),
    );

    final iconSize = WidgetStateProperty.resolveWith<double>(
      (states) => _buttonIconSize(),
    );

    final ButtonStyle startStyle = startTheme.style ?? const ButtonStyle();
    final ButtonStyle style = startStyle.copyWith(
      textStyle: textStyle,
      backgroundColor: backColor,
      iconColor: foregroundColor,
      foregroundColor: foregroundColor,
      shape: _buttonShape(),
      minimumSize: minSize,
      padding: padding,
      iconSize: iconSize,
    );

    return FilledButtonThemeData(style: style);
  }

  TextButtonThemeData textButtonTheme() {
    final startTheme = baseTheme.textButtonTheme;

    final foregroundColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _buttonTextColor(states: states, filledButton: false),
    );

    final textStyle = WidgetStateProperty.resolveWith<TextStyle>(
      (states) => _buttonTextStyle(states: states),
    );

    final padding = WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
      (states) => _buttonPadding(states),
    );

    final minSize = WidgetStateProperty.resolveWith<Size>(
      (states) => _buttonMinSize(),
    );

    final iconSize = WidgetStateProperty.resolveWith<double>(
      (states) => _buttonIconSize(),
    );

    final startStyle = startTheme.style ?? const ButtonStyle();
    final ButtonStyle style = startStyle.copyWith(
      iconColor: foregroundColor,
      foregroundColor: foregroundColor,
      shape: _buttonShape(),
      textStyle: textStyle,
      minimumSize: minSize,
      padding: padding,
      iconSize: iconSize,
    );

    return TextButtonThemeData(style: style);
  }

  OutlinedButtonThemeData outlineButtonTheme() {
    final startTheme = baseTheme.outlinedButtonTheme;

    final borderSide = WidgetStateProperty.resolveWith<BorderSide>(
      (states) => _borderSide(states),
    );

    final foregroundColor = WidgetStateProperty.resolveWith<Color>(
      (states) => _buttonTextColor(states: states, filledButton: false),
    );

    final textStyle = WidgetStateProperty.resolveWith<TextStyle>(
      (states) => _buttonTextStyle(states: states),
    );

    final padding = WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
      (states) => _buttonPadding(states),
    );

    final minSize = WidgetStateProperty.resolveWith<Size>(
      (states) => _buttonMinSize(),
    );

    final iconSize = WidgetStateProperty.resolveWith<double>(
      (states) => _buttonIconSize(),
    );

    final startStyle = startTheme.style ?? const ButtonStyle();
    final ButtonStyle style = startStyle.copyWith(
      side: borderSide,
      textStyle: textStyle,
      iconColor: foregroundColor,
      foregroundColor: foregroundColor,
      shape: _buttonShape(),
      minimumSize: minSize,
      padding: padding,
      iconSize: iconSize,
    );

    return OutlinedButtonThemeData(style: style);
  }

  // ===============================================================

  Color _backColor(Set<WidgetState> states) {
    final darker = baseTheme.colorScheme.primary.darker();
    final lighter = baseTheme.colorScheme.primary.lighter(factor: 0.2);

    if (ThemeUtils.isHovered(states)) {
      return darker;
    }

    if (ThemeUtils.isDisabled(states)) {
      return lighter;
    }

    return baseTheme.colorScheme.primary;
  }

  TextStyle _buttonTextStyle({required Set<WidgetState> states}) {
    // google font set by caller was ignored unless we copy the labelLarge
    final style = baseTheme.textTheme.labelLarge ?? const TextStyle();

    return style.copyWith(
      fontWeight: (boldButtons ?? false) ? Font.bold : null,
      fontSize: (buttonFontSize != null) ? buttonFontSize : null,
    );
  }

  Color _buttonTextColor({
    required Set<WidgetState> states,
    required bool filledButton,
  }) {
    Color baseColor =
        whiteButtons ? Colors.white : baseTheme.colorScheme.primary;
    Color baseColorLight =
        whiteButtons
            ? Colors.white.lighter(factor: 0.2)
            : baseTheme.colorScheme.primary.lighter(factor: 0.2);

    if (filledButton) {
      baseColor = baseTheme.colorScheme.onPrimary;
      // Utils.lighten won't work for white
      baseColorLight = baseTheme.colorScheme.onPrimary.withValues(alpha: 0.6);
    }

    // if (states.any(_interactiveStates.contains)) {
    //   return Utils.darken(baseColor);
    // }

    if (ThemeUtils.isDisabled(states)) {
      return baseColorLight;
    }

    return baseColor;
  }

  EdgeInsets _buttonPadding(Set<WidgetState> states) {
    return const EdgeInsets.symmetric(horizontal: 18, vertical: 14);
  }

  WidgetStateProperty<OutlinedBorder> _buttonShape() {
    return WidgetStateProperty.resolveWith<OutlinedBorder>(
      (states) => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  double _buttonIconSize() {
    return 20;
  }

  Size _buttonMinSize() {
    return const Size(88, 0);
  }

  BorderSide _borderSide(Set<WidgetState> states) {
    Color color =
        whiteButtons ? Colors.white : baseTheme.colorScheme.outlineVariant;

    final darker = color.darker();
    final lighter = color.lighter(factor: 0.2);

    if (ThemeUtils.isHovered(states)) {
      color = darker;
    }

    if (ThemeUtils.isDisabled(states)) {
      color = lighter;
    }

    return BorderSide(color: color);
  }
}
