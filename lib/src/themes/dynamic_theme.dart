import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/themes/themes.dart';
import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

class DynamicTheme with ChangeNotifier {
  DynamicTheme() {
    _themeSet = ThemeSetManager().currentTheme;

    Preferences().addListener(() {
      final ThemeSet? newTheme = ThemeSetManager().currentTheme;
      if (_themeSet != newTheme) {
        _themeSet = newTheme;
        _appTheme = null;

        notifyListeners();
      }
    });
  }

  ThemeSet? _themeSet;

  AppTheme? _appTheme;

  ThemeData get theme => appTheme().theme;
  ThemeData get darkTheme => appTheme(darkMode: true).theme;

  ThemeData transparentTheme(BuildContext context) {
    return appTheme(
            transparentAppBar: true, darkMode: Utils.isDarkMode(context))
        .theme;
  }

  // for game window with black background
  ThemeData get transparentDarkTheme =>
      appTheme(transparentAppBar: true, darkMode: true).theme;

  AppTheme appTheme({bool transparentAppBar = false, bool darkMode = false}) {
    if (_appTheme != null) {
      if (_appTheme!.darkMode != darkMode) {
        _appTheme = null;
      } else if (transparentAppBar != _appTheme!.transparentAppBar) {
        _appTheme = null;
      }
    }

    return _appTheme ??= AppTheme(
        darkMode: darkMode,
        integratedAppBar: ThemeSetManager().integratedAppBar,
        transparentAppBar: transparentAppBar,
        googleFont: ThemeSetManager().googleFont);
  }
}
