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
}
