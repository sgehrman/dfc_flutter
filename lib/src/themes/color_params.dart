import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';

class ColorParams {
  ColorParams({this.integratedAppBar = true, this.transparentAppBar = false}) {
    final ThemeSet themeSet = ThemeSetManager().currentTheme!;

    appColor = themeSet.primaryColor;
    accentColor = themeSet.accentColor;

    barColor = appColor;
    barColorDark = appColor;

    if (integratedAppBar!) {
      barTextColor = themeSet.textColor;
      barTextColorDark = themeSet.textColor;
    } else {
      barTextColor = Colors.black;
      barTextColorDark = Colors.white;
    }

    // our app bar color is dark colored, so use the 'dark' test color
    darkModeAppBarText = true;

    // out buttons are dark colored, so use the 'dark' test color
    darkModeForButtonText = true;

    // modifications for integrated app bar
    if (integratedAppBar!) {
      _withIntegratedAppBar(themeSet);
    }
  }

  bool? integratedAppBar;
  bool? transparentAppBar;

  Color? appColor;
  Color? accentColor;

  Color? barColor;
  Color? barColorDark;

  Color? barTextColor;
  Color? barTextColorDark;

  // set this to true for whiteish barColors
  late bool darkModeAppBarText;
  late bool darkModeForButtonText;

  double get barElevation {
    if (integratedAppBar!) {
      return 0;
    }

    return 4;
  }

  Color? getBarTextColor({required bool darkMode}) {
    return darkMode ? barTextColorDark : barTextColor;
  }

  void _withIntegratedAppBar(ThemeSet? themeSet) {
    if (transparentAppBar!) {
      barColor = Colors.transparent;
      barColorDark = Colors.transparent;
    } else {
      if (themeSet != null) {
        barColor = themeSet.backgroundColor;
        barColorDark = themeSet.backgroundColor;
      } else {
        barColor =
            ThemeData(brightness: Brightness.light).scaffoldBackgroundColor;
        barColorDark =
            ThemeData(brightness: Brightness.dark).scaffoldBackgroundColor;
      }
    }

    // our app bar color whatever the background is, so just use the normal color
    darkModeAppBarText = false;
  }
}
