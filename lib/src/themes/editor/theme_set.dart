import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

enum ThemeSetColor {
  primaryColor,
  accentColor,
  backgroundColor,
  textAccentColor,
  textColor,
  buttonContentColor,
  headerTextColor,
}

class ThemeSet {
  const ThemeSet({
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.backgroundColor,
    required this.textAccentColor,
    required this.textColor,
    required this.headerTextColor,
    required this.buttonContentColor,
    required this.fontName,
    required this.integratedAppBar,
    required this.dividerLines,
    required this.lightBackground,
  });

  factory ThemeSet.defaultSet() {
    if (Utils.isNotEmpty(_appDefaultSet)) {
      return ThemeSet.fromMap(
          Map<String, dynamic>.from(json.decode(_appDefaultSet!) as Map));
    }

    return ThemeSet(
      name: 'Default',
      primaryColor: Colors.cyan,
      accentColor: Colors.pink[300],
      headerTextColor: Colors.grey,
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      textAccentColor: Colors.grey,
      textColor: Colors.white,
      buttonContentColor: Colors.white,
      fontName: 'robotoTextTheme',
      integratedAppBar: true,
      dividerLines: false,
      lightBackground: false,
    );
  }

  factory ThemeSet.fromMap(Map<String, dynamic> map) {
    return ThemeSet(
      name: map['name'] as String?,
      primaryColor: _colorFromInt(map['primaryColor']),
      accentColor: _colorFromInt(map['accentColor']),
      headerTextColor: _colorFromInt(map['headerTextColor']),
      backgroundColor: _colorFromInt(map['backgroundColor']),
      textAccentColor: _colorFromInt(map['textAccentColor']),
      textColor: _colorFromInt(map['textColor']),
      buttonContentColor: _colorFromInt(map['buttonContentColor']),
      fontName: map['fontName'] as String?,
      integratedAppBar: map['integratedAppBar'] as bool?,
      dividerLines: map['dividerLines'] as bool?,
      lightBackground: map['lightBackground'] as bool?,
    );
  }

  // the app sets this at startup if they don't like the hard coded default
  static String? _appDefaultSet;
  static set appsDefaultSet(String set) => _appDefaultSet = set;

  static Color? _colorFromInt(dynamic color) {
    if (color != null && color is int) {
      return Color(color);
    }

    return null;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'primaryColor': primaryColor?.value,
      'accentColor': accentColor?.value,
      'headerTextColor': headerTextColor?.value,
      'backgroundColor': backgroundColor?.value,
      'textAccentColor': textAccentColor?.value,
      'textColor': textColor?.value,
      'buttonContentColor': buttonContentColor?.value,
      'fontName': fontName,
      'integratedAppBar': integratedAppBar,
      'dividerLines': dividerLines,
      'lightBackground': lightBackground,
    };
  }

  final String? name;
  final Color? primaryColor;
  final Color? accentColor;
  final Color? headerTextColor;
  final Color? textColor;
  final Color? buttonContentColor;
  final Color? textAccentColor;
  final Color? backgroundColor;

  final String? fontName;
  final bool? integratedAppBar;
  final bool? dividerLines;
  final bool? lightBackground;

  @override
  String toString() {
    return toMap().toString();
  }

  Color? colorForField(ThemeSetColor field) {
    switch (field) {
      case ThemeSetColor.primaryColor:
        return primaryColor;
      case ThemeSetColor.accentColor:
        return accentColor;
      case ThemeSetColor.textColor:
        return textColor;
      case ThemeSetColor.buttonContentColor:
        return buttonContentColor;
      case ThemeSetColor.textAccentColor:
        return textAccentColor;
      case ThemeSetColor.backgroundColor:
        return backgroundColor;
      case ThemeSetColor.headerTextColor:
        return headerTextColor;
    }
  }

  ThemeSet copyWith({
    String? name,
    String? fontName,
    bool? integratedAppBar,
    bool? lightBackground,
  }) {
    return ThemeSet(
      name: name ?? this.name,
      primaryColor: primaryColor,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      textAccentColor: textAccentColor,
      textColor: textColor,
      buttonContentColor: buttonContentColor,
      headerTextColor: headerTextColor,
      fontName: fontName ?? this.fontName,
      integratedAppBar: integratedAppBar ?? this.integratedAppBar,
      dividerLines: dividerLines,
      lightBackground: lightBackground ?? this.lightBackground,
    );
  }

  ThemeSet copyWithColor(ThemeSetColor field, Color color) {
    return ThemeSet(
      name: name,
      primaryColor: field == ThemeSetColor.primaryColor ? color : primaryColor,
      accentColor: field == ThemeSetColor.accentColor ? color : accentColor,
      backgroundColor:
          field == ThemeSetColor.backgroundColor ? color : backgroundColor,
      textAccentColor:
          field == ThemeSetColor.textAccentColor ? color : textAccentColor,
      textColor: field == ThemeSetColor.textColor ? color : textColor,
      buttonContentColor: field == ThemeSetColor.buttonContentColor
          ? color
          : buttonContentColor,
      headerTextColor:
          field == ThemeSetColor.headerTextColor ? color : headerTextColor,
      fontName: fontName,
      integratedAppBar: integratedAppBar,
      dividerLines: dividerLines,
      lightBackground: lightBackground,
    );
  }

  String nameForField(ThemeSetColor field) {
    switch (field) {
      case ThemeSetColor.primaryColor:
        return 'Primary Color';
      case ThemeSetColor.accentColor:
        return 'Accent Color';
      case ThemeSetColor.textColor:
        return 'Text Color';
      case ThemeSetColor.buttonContentColor:
        return 'Button Content Color';
      case ThemeSetColor.textAccentColor:
        return 'Text Accent Color';
      case ThemeSetColor.backgroundColor:
        return 'Background Color';
      case ThemeSetColor.headerTextColor:
        return 'Header Text Color';
    }
  }

  bool contentIsEqual(ThemeSet other) {
    final ThemeSet sameName = other.copyWith(name: name);

    return sameName == this;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is ThemeSet) {
      if (other.name == name &&
          Utils.equalColors(primaryColor, other.primaryColor) &&
          Utils.equalColors(accentColor, other.accentColor) &&
          Utils.equalColors(textColor, other.textColor) &&
          Utils.equalColors(buttonContentColor, other.buttonContentColor) &&
          Utils.equalColors(backgroundColor, other.backgroundColor) &&
          Utils.equalColors(headerTextColor, other.headerTextColor) &&
          Utils.equalColors(textAccentColor, other.textAccentColor) &&
          other.fontName == fontName &&
          other.integratedAppBar == integratedAppBar &&
          other.dividerLines == dividerLines &&
          other.lightBackground == lightBackground) {
        return true;
      }
    }

    return false;
  }

  @override
  int get hashCode => hashValues(
        name,
        primaryColor,
        accentColor,
        textColor,
        textAccentColor,
        buttonContentColor,
        backgroundColor,
        headerTextColor,
        fontName,
        integratedAppBar,
        dividerLines,
        lightBackground,
      );
}
