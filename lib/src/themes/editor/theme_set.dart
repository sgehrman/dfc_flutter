import 'dart:convert';

import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

enum ThemeSetColor {
  primaryColor,
  accentColor,
  backgroundColor,
  textAccentColor,
  textColor,
  buttonContentColor,
  headerTextColor,
  cardColor,
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
    required this.cardColor,
    required this.cardElevation,
    required this.buttonContentColor,
    required this.fontName,
    required this.integratedAppBar,
    required this.dividerLines,
    required this.lightBackground,
  });

  factory ThemeSet.defaultSet() {
    if (Utils.isNotEmpty(_appDefaultSet)) {
      return ThemeSet.fromMap(
        Map<String, dynamic>.from(json.decode(_appDefaultSet!) as Map),
      );
    }

    return ThemeSet(
      name: 'Default',
      primaryColor: Colors.cyan,
      accentColor: Colors.pink[300]!,
      headerTextColor: Colors.grey,
      cardColor: Colors.white,
      cardElevation: 1,
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      textAccentColor: Colors.grey,
      textColor: Colors.white,
      buttonContentColor: Colors.white,
      fontName: 'roboto',
      integratedAppBar: true,
      dividerLines: false,
      lightBackground: false,
    );
  }

  factory ThemeSet.fromMap(Map<String, dynamic> map) {
    final defaults = ThemeSet.defaultSet();

    return ThemeSet(
      name: map['name'] as String,
      primaryColor: _colorFromInt(map['primaryColor']) ?? defaults.primaryColor,
      accentColor: _colorFromInt(map['accentColor']) ?? defaults.accentColor,
      headerTextColor:
          _colorFromInt(map['headerTextColor']) ?? defaults.headerTextColor,
      backgroundColor:
          _colorFromInt(map['backgroundColor']) ?? defaults.backgroundColor,
      textAccentColor:
          _colorFromInt(map['textAccentColor']) ?? defaults.textAccentColor,
      textColor: _colorFromInt(map['textColor']) ?? defaults.textColor,
      buttonContentColor: _colorFromInt(map['buttonContentColor']) ??
          defaults.buttonContentColor,
      fontName: map['fontName'] as String? ?? defaults.fontName,
      integratedAppBar:
          map['integratedAppBar'] as bool? ?? defaults.integratedAppBar,
      dividerLines: map['dividerLines'] as bool? ?? defaults.dividerLines,
      lightBackground:
          map['lightBackground'] as bool? ?? defaults.lightBackground,
      cardColor: _colorFromInt(map['cardColor']) ?? defaults.cardColor,
      cardElevation:
          map['buttonContentColor'] as double? ?? defaults.cardElevation,
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
      'primaryColor': primaryColor.value,
      'accentColor': accentColor.value,
      'headerTextColor': headerTextColor.value,
      'backgroundColor': backgroundColor.value,
      'textAccentColor': textAccentColor.value,
      'textColor': textColor.value,
      'buttonContentColor': buttonContentColor.value,
      'fontName': fontName,
      'integratedAppBar': integratedAppBar,
      'dividerLines': dividerLines,
      'lightBackground': lightBackground,
      'cardColor': cardColor.value,
      'cardElevation': cardElevation,
    };
  }

  final String name;
  final Color primaryColor;
  final Color accentColor;
  final Color headerTextColor;
  final Color textColor;
  final Color buttonContentColor;
  final Color textAccentColor;
  final Color backgroundColor;
  final Color cardColor;
  final double cardElevation;

  final String fontName;
  final bool integratedAppBar;
  final bool dividerLines;
  final bool lightBackground;

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
      case ThemeSetColor.cardColor:
        return cardColor;
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
      cardColor: cardColor,
      cardElevation: cardElevation,
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
      cardColor: cardColor,
      cardElevation: cardElevation,
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
      case ThemeSetColor.cardColor:
        return 'Card Color';
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
          Utils.equalColors(cardColor, other.cardColor) &&
          other.fontName == fontName &&
          other.integratedAppBar == integratedAppBar &&
          other.dividerLines == dividerLines &&
          other.cardElevation == cardElevation &&
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
        cardColor,
        cardElevation,
        fontName,
        integratedAppBar,
        dividerLines,
        lightBackground,
      );
}
