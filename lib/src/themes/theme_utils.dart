import 'package:flutter/material.dart';

class ThemeUtils {
  ThemeUtils._();

  static void debugStates(Set<WidgetState> states) {
    if (states.isNotEmpty) {
      print('## START: debug states ##');

      if (isSelected(states)) {
        print('isSelected');
      }

      if (isHovered(states)) {
        print('isHovered');
      }

      if (isDisabled(states)) {
        print('isDisabled');
      }

      if (isFocused(states)) {
        print('isFocused');
      }

      if (isError(states)) {
        print('isError');
      }

      if (isDragged(states)) {
        print('isDragged');
      }

      if (isPressed(states)) {
        print('isPressed');
      }

      if (isScrolledUnder(states)) {
        print('isScrolledUnder');
      }

      print('## END: debug states ##');
    }
  }

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

  static bool isError(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.error,
      }.contains,
    );
  }

  static bool isFocused(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.focused,
      }.contains,
    );
  }

  static bool isDragged(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.dragged,
      }.contains,
    );
  }

  static bool isPressed(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.pressed,
      }.contains,
    );
  }

  static bool isScrolledUnder(Set<WidgetState> states) {
    return states.any(
      <WidgetState>{
        WidgetState.scrolledUnder,
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
