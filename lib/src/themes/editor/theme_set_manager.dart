import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/string_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ThemeSetManager {
  factory ThemeSetManager() {
    return _instance ??= ThemeSetManager._();
  }
  ThemeSetManager._() {
    _currentTheme = Preferences().themeSet ?? ThemeSet.defaultSet();
  }
  static ThemeSetManager? _instance;

  ThemeSet? _currentTheme;

  ThemeSet? get currentTheme => _currentTheme;
  set currentTheme(ThemeSet? themeSet) {
    _currentTheme = themeSet;

    Preferences().themeSet = themeSet;
  }

  static List<ThemeSet> get themeSets {
    final List<ThemeSet> result = [];

    result.addAll(_defaultSets());

    final List<ThemeSet>? fromPrefs = Preferences().themeSets;

    if (Utils.isNotEmpty(fromPrefs)) {
      result.addAll(fromPrefs!);
    }

    return result;
  }

  static String? _uniqueNameForThemeSet(ThemeSet themeSet) {
    String? uniqueName = themeSet.name;

    for (int i = 1; i < 1000; i++) {
      final bool nameTaken =
          themeSets.any((element) => uniqueName == element.name);

      if (!nameTaken) {
        break;
      }

      uniqueName = '${themeSet.name}-$i';
    }

    return uniqueName;
  }

  // set replace false to generate a unique
  static ThemeSet saveTheme(ThemeSet themeSet, {bool scanned = false}) {
    ThemeSet resultTheme = themeSet;

    // print for creating defaults
    StrUtils.print(json.encode(themeSet.toMap()));

    // return if already exists
    final bool exists = themeSets.any((test) => themeSet == test);
    if (!exists) {
      List<ThemeSet> newSets = [];

      newSets.addAll(Preferences().themeSets ?? []);

      // a normal save does a replace, so it replaces the same named set
      // a scan might have the same name, but different contents, don't want to wipe users set with same name
      if (scanned) {
        // bail out if another theme has same content, but different name
        final ThemeSet? foundTheme =
            themeSets.firstWhereOrNull((test) => themeSet.contentIsEqual(test));

        if (foundTheme == null) {
          resultTheme =
              themeSet.copyWith(name: _uniqueNameForThemeSet(themeSet));
          newSets.add(resultTheme);
        } else {
          resultTheme = foundTheme;
        }
      } else {
        // remove the one with the same name if exists
        final int lengthBefore = newSets.length;
        newSets = newSets.where((x) => themeSet.name != x.name).toList();

        // not replacing, it's new with a new name
        if (lengthBefore == newSets.length) {
          // make sure name is unique
          resultTheme =
              themeSet.copyWith(name: _uniqueNameForThemeSet(themeSet));
          newSets.add(resultTheme);
        } else {
          newSets.add(themeSet);
        }
      }

      Preferences().themeSets = newSets;
    }

    // set current theme
    ThemeSetManager().currentTheme = resultTheme;

    return resultTheme;
  }

  static void deleteTheme(ThemeSet themeSet) {
    List<ThemeSet> newSets = [];

    newSets.addAll(Preferences().themeSets ?? []);

    // remove with same name
    newSets = newSets.where((x) => themeSet.name != x.name).toList();

    Preferences().themeSets = newSets;
  }

  String get googleFont => _currentTheme!.fontName;
  set googleFont(String fontName) {
    final newTheme = currentTheme!.copyWith(fontName: fontName);

    currentTheme = newTheme;
  }

  bool get integratedAppBar => currentTheme!.integratedAppBar;
  set integratedAppBar(bool value) {
    final newTheme = currentTheme!.copyWith(integratedAppBar: value);

    currentTheme = newTheme;
  }

  bool get lightBackground => currentTheme!.lightBackground;
  set lightBackground(bool value) {
    final newTheme = currentTheme!.copyWith(lightBackground: value);

    currentTheme = newTheme;
  }

  static TextStyle header(BuildContext context) {
    return Theme.of(context).textTheme.headline4!;
  }

  static List<ThemeSet> _defaultSets() {
    // json for sets, output to console to create new defaults
    final List<String> jsonSets = [
      '{"name":"CyberPunk","primaryColor":4278238420,"accentColor":4293943954,"headerTextColor":4288585374,"backgroundColor":4279379760,"textAccentColor":4288585374,"textColor":4294967295,"buttonContentColor":4294967295,"fontName":"audiowideTextTheme","integratedAppBar":true,"dividerLines":false,"lightBackground":false}',
      '{"name":"Terminal","primaryColor":4281167409,"accentColor":4281896508,"headerTextColor":4283215696,"backgroundColor":4278395161,"textAccentColor":4284523363,"textColor":4278775826,"buttonContentColor":4294967295,"fontName":null,"integratedAppBar":true,"dividerLines":false,"lightBackground":false}',
      '{"name":"Boomer","primaryColor":4279716220,"accentColor":4284643568,"headerTextColor":4288585374,"backgroundColor":4294966781,"textAccentColor":4288585374,"textColor":4278190080,"buttonContentColor":4294967295,"fontName":"robotoTextTheme","integratedAppBar":false,"dividerLines":false,"lightBackground":true}',
      '{"name":"Pink Lady","primaryColor":4290782133,"accentColor":4294540773,"headerTextColor":4294801123,"backgroundColor":4292624561,"textAccentColor":4294024701,"textColor":4294967295,"buttonContentColor":4294967295,"fontName":"robotoTextTheme","integratedAppBar":true,"dividerLines":false,"lightBackground":false}',
    ];

    // strings to maps
    final List<Map<String, dynamic>> mapsList = jsonSets
        .map((set) => Map<String, dynamic>.from(json.decode(set) as Map))
        .toList();

    // maps to themeSets
    final List<ThemeSet> themeList =
        mapsList.map((map) => ThemeSet.fromMap(map)).toList();

    return [
      ThemeSet.defaultSet(),
      ...themeList,
    ];
  }
}
