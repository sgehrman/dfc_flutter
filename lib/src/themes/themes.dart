import 'package:dfc_flutter/src/google_fonts/google_font_library.dart';
import 'package:dfc_flutter/src/themes/color_params.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme({
    required this.darkMode,
    required this.transparentAppBar,
    required this.themeSet,
  });

  bool darkMode;
  bool transparentAppBar;
  ThemeSet themeSet;

  ThemeData get theme {
    ColorParams params;

    params = ColorParams(
      integratedAppBar: themeSet.integratedAppBar,
      transparentAppBar: transparentAppBar,
      themeSet: themeSet,
    );

    final Color? appColor = params.appColor;

    final sliderTheme = SliderThemeData(
      activeTrackColor: appColor,
      disabledActiveTrackColor: appColor,
      disabledInactiveTrackColor: appColor,
      disabledThumbColor: appColor,
      inactiveTrackColor: appColor,
      thumbColor: appColor,
    );

    const floatingActionButtonTheme = FloatingActionButtonThemeData(
      // white on floatingAction button
      foregroundColor: Colors.white,
    );

    final iconTheme = IconThemeData(color: themeSet.textColor);

    final popupMenuTheme = PopupMenuThemeData(
      color: themeSet.backgroundColor,
    );

    final tabBarTheme = TabBarTheme(
      labelColor: appColor,
    );

    final baseTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: themeSet.backgroundColor,
      drawerTheme: DrawerThemeData(
        backgroundColor: themeSet.backgroundColor,
      ),
      tabBarTheme: tabBarTheme,
      popupMenuTheme: popupMenuTheme,
      bottomAppBarTheme: _bottomBarTheme(darkMode),
      bottomNavigationBarTheme: _bottomNavBarTheme(appColor),
      textTheme: _textTheme(darkMode),
      iconTheme: iconTheme,
      dividerTheme: DividerThemeData(
        thickness: 1, // web needs this, otherwise invisible
        space: 2,
        color: darkMode
            ? Colors.white12
            : const Color.fromRGBO(
                0,
                0,
                0,
                0.05,
              ),
      ),
      primaryColor: appColor,
      primaryColorLight: appColor, // circle avatar uses these light/dark
      primaryColorDark: appColor,
      dialogBackgroundColor: themeSet.backgroundColor,
      sliderTheme: sliderTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      colorScheme: _colorScheme(
        darkMode: darkMode,
        primary: appColor,
        secondary: params.accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeSet.textAccentColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: themeSet.textAccentColor),
        ),
        hintStyle: TextStyle(color: themeSet.textAccentColor),
        labelStyle: TextStyle(color: themeSet.textAccentColor),
        helperStyle: TextStyle(color: themeSet.textAccentColor),
      ),
      cardTheme: CardTheme(
        color: themeSet.cardColor,
        elevation: themeSet.cardElevation,
      ),
    );

    if (darkMode) {
      return baseTheme.copyWith(
        brightness: Brightness.dark,
        appBarTheme: _appBarTheme(true, params),
        buttonTheme: _buttonTheme(true),
        textButtonTheme: _textButtonTheme(true),
        elevatedButtonTheme: _elevatedButtonTheme(true),
      );
    }

    return baseTheme.copyWith(
      brightness: Brightness.light,
      appBarTheme: _appBarTheme(params.darkModeAppBarText, params),
      buttonTheme: _buttonTheme(params.darkModeForButtonText),
      textButtonTheme: _textButtonTheme(params.darkModeForButtonText),
      elevatedButtonTheme: _elevatedButtonTheme(params.darkModeForButtonText),
    );
  }

  // change the global font here
  TextTheme _fontChange(TextTheme theme) {
    return themeWithGoogleFont(themeSet.fontName, theme);
  }

  TextTheme _textTheme(bool darkMode) {
    Color? textColor = Colors.black;

    if (darkMode) {
      textColor = Colors.white;
    }

    Color? subtitleColor = Utils.darken(textColor);
    Color? headerTextColor = Colors.grey;
    Color? buttonContentColor = Colors.white;

    textColor = themeSet.textColor;
    subtitleColor = themeSet.textAccentColor;
    headerTextColor = themeSet.headerTextColor;
    buttonContentColor = themeSet.buttonContentColor;

    TextTheme startTheme = ThemeData.light().textTheme;

    if (darkMode) {
      startTheme = ThemeData.dark().textTheme;
    }

    final result = startTheme.copyWith(
      labelLarge: TextStyle(
        color: buttonContentColor,
      ),

      // used for ListTile title in drawer
      bodyLarge: startTheme.bodyLarge!.copyWith(
        fontSize: 17,
        color: textColor,
      ),

      // used for ListTile subtitle in non-drawer list
      bodyMedium: startTheme.bodyMedium!.copyWith(
        color: textColor,
        fontSize: 16,
      ),

      // used for control text
      titleMedium: startTheme.bodyLarge!.copyWith(
        fontSize: 16,
        color: textColor,
      ),

      // used for header title
      headlineMedium: TextStyle(
        color: headerTextColor,
        fontWeight: Font.bold,
        fontSize: 17,
      ),

      // Google fonts list and others
      titleLarge: startTheme.titleLarge!.copyWith(
        color: textColor,
      ),

      // used for listTile subtitle
      bodySmall: startTheme.bodyLarge!.copyWith(
        fontSize: 15,
        color: subtitleColor,
      ),
    );

    return _fontChange(result);
  }

  TextStyle _appBarTextStyle(bool darkMode, ColorParams params) {
    return TextStyle(
      color: params.getBarTextColor(darkMode: darkMode),
      fontSize: 18,
      // fontWeight: Font.bold,
    );
  }

  ButtonThemeData _buttonTheme(bool darkMode) {
    ButtonThemeData startTheme = ThemeData.light().buttonTheme;
    if (darkMode) {
      startTheme = ThemeData.dark().buttonTheme;
    }

    return startTheme.copyWith(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  ColorScheme _colorScheme({
    required bool darkMode,
    Color? primary,
    Color? secondary,
  }) {
    ColorScheme scheme = ThemeData.light().colorScheme;
    if (darkMode) {
      scheme = ThemeData.dark().colorScheme;
    }

    final Color buttonContentColor = themeSet.buttonContentColor;

    return scheme.copyWith(
      primary: primary,
      secondary: secondary,
      onPrimary: buttonContentColor,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    );
  }

  ElevatedButtonThemeData _elevatedButtonTheme(bool darkMode) {
    ElevatedButtonThemeData startTheme = ThemeData.light().elevatedButtonTheme;
    if (darkMode) {
      startTheme = ThemeData.dark().elevatedButtonTheme;
    }

    return ElevatedButtonThemeData(style: startTheme.style);
  }

  TextButtonThemeData _textButtonTheme(bool darkMode) {
    TextButtonThemeData startTheme = ThemeData.light().textButtonTheme;
    if (darkMode) {
      startTheme = ThemeData.dark().textButtonTheme;
    }

    return TextButtonThemeData(style: startTheme.style);
  }

  AppBarTheme _appBarTheme(bool darkMode, ColorParams params) {
    return AppBarTheme(
      color: darkMode ? params.barColorDark : params.barColor,
      elevation: params.barElevation,
      iconTheme:
          IconThemeData(color: params.getBarTextColor(darkMode: darkMode)),
      actionsIconTheme: IconThemeData(
        color: params.getBarTextColor(darkMode: darkMode),
      ),
      titleTextStyle: _appBarTextStyle(darkMode, params),
    );
  }

  BottomAppBarTheme _bottomBarTheme(bool darkMode) {
    return BottomAppBarTheme(
      color: darkMode ? Colors.white : Colors.black,
    );
  }

  BottomNavigationBarThemeData _bottomNavBarTheme(Color? itemColor) {
    return BottomNavigationBarThemeData(
      selectedItemColor: itemColor,
      unselectedItemColor: itemColor,
      elevation: 8,
      backgroundColor: themeSet.backgroundColor,
    );
  }
}
