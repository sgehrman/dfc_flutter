import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/hive_db/hive_box.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:flutter/material.dart';

class Preferences extends ChangeNotifier {
  factory Preferences() {
    return _instance ??= Preferences._();
  }

  Preferences._() {
    prefs.listenable()!.addListener(() {
      notifyListeners();
    });
  }

  static Preferences? _instance;

  HiveBox get prefs {
    return HiveBox.prefsBox;
  }

  void clearPrefs() {
    prefs.clear();
  }

  static String? get loginEmail =>
      HiveBox.prefsBox.get('loginEmail', defaultValue: null) as String?;
  static set loginEmail(String? email) =>
      HiveBox.prefsBox.put('loginEmail', email);

  static String? get loginName =>
      HiveBox.prefsBox.get('loginName', defaultValue: null) as String?;
  static set loginName(String? email) =>
      HiveBox.prefsBox.put('loginName', email);

  static String? get loginPhone =>
      HiveBox.prefsBox.get('loginPhone', defaultValue: null) as String?;
  static set loginPhone(String? phone) =>
      HiveBox.prefsBox.put('loginPhone', phone);

  bool? get showPerformanceOverlay =>
      prefs.get('perfOverlay', defaultValue: false) as bool?;

  set showPerformanceOverlay(bool? value) {
    if (showPerformanceOverlay != value) {
      prefs.put('perfOverlay', value);
    }
  }

  // tooltips
  static bool get disableTooltips =>
      HiveBox.prefsBox.get('disableTooltips', defaultValue: false) as bool;
  static set disableTooltips(bool? flag) =>
      HiveBox.prefsBox.put('disableTooltips', flag);

  bool? get showCheckerboardImages =>
      prefs.get('checkerboardImages', defaultValue: false) as bool?;

  set showCheckerboardImages(bool? value) {
    if (showCheckerboardImages != value) {
      prefs.put('checkerboardImages', value);
    }
  }

  bool? get showCheckerboardLayers =>
      prefs.get('checkerboardLayers', defaultValue: false) as bool?;

  set showCheckerboardLayers(bool? value) {
    if (showCheckerboardLayers != value) {
      prefs.put('checkerboardLayers', value);
    }
  }

  List<String?> getFavoriteGoogleFonts() => List<String?>.from(
        prefs.get('favoriteGoogleFonts', defaultValue: <String>[]) as List,
      );

  void setFavoriteGoogleFonts(List<String?> value) {
    if (getFavoriteGoogleFonts() != value) {
      prefs.put('favoriteGoogleFonts', value);
    }
  }

  ThemeSet? get themeSet {
    final jsonMap = prefs.get('themeSet') as Map?;

    if (jsonMap != null) {
      return ThemeSet.fromMap(Map<String, dynamic>.from(jsonMap));
    }

    return null;
  }

  // pass null to delete pref
  set themeSet(ThemeSet? newTheme) {
    if (newTheme == null) {
      prefs.delete('themeSet');
    } else {
      if (themeSet != newTheme) {
        prefs.put('themeSet', newTheme.toMap());
      }
    }
  }

  List<ThemeSet>? get themeSets {
    final dynamic pref = prefs.get('themeSets');

    if (pref != null) {
      final jsonList = List<Map>.from(pref as List);

      return jsonList
          .map(
            (jsonMap) => ThemeSet.fromMap(Map<String, dynamic>.from(jsonMap)),
          )
          .toList();
    }

    return null;
  }

  // pass null to delete
  set themeSets(List<ThemeSet>? newThemes) {
    if (newThemes == null) {
      prefs.delete('themeSets');
    } else {
      final List<Map> maps = newThemes.map((x) => x.toMap()).toList();

      prefs.put('themeSets', maps);
    }
  }

  List<ServerFile>? get favorites {
    final dynamic pref = prefs.get('favorites');

    if (pref != null) {
      final jsonList = List<Map>.from(pref as List);

      return jsonList
          .map(
            (jsonMap) => ServerFile.fromMap(Map<String, dynamic>.from(jsonMap)),
          )
          .toList();
    }

    return null;
  }

  // pass null to delete
  set favorites(List<ServerFile>? favs) {
    if (favs == null) {
      prefs.delete('favorites');
    } else {
      final List<Map> maps = favs.map((x) => x.toMap()).toList();

      prefs.put('favorites', maps);
    }
  }
}
