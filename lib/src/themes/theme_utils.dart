import 'package:flutter/material.dart';

class ThemeUtils {
  ThemeUtils._();

  static bool isSelected(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.selected,
      }.contains,
    );
  }

  static bool isHovered(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.hovered,
      }.contains,
    );
  }

  static bool isDisabled(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.disabled,
      }.contains,
    );
  }

  // Returns true if the color's brightness is [Brightness.light], else false.
  static bool isLightColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light;
  }

  // Returns true if the color's brightness is [Brightness.dark], else false.
  static bool isDarkColor(Color color) {
    // could also use this?
    // return color.computeLuminance() <= 0.5;

    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  }
}
