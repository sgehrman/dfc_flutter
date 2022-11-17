import 'dart:convert';

import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/hive_db/hive_box.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/utils/debouncer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Preferences {
  factory Preferences() {
    return _instance ??= Preferences._();
  }

  Preferences._();

  static Preferences? _instance;

  HiveBox<dynamic> get prefs {
    return HiveBox.prefsBox;
  }

  void clearPrefs() {
    prefs.clear();
  }

  String get loginEmail => prefs.get('loginEmail', defaultValue: '') as String;
  set loginEmail(String? email) => prefs.put('loginEmail', email);

  String get loginName => prefs.get('loginName', defaultValue: '') as String;
  set loginName(String? email) => prefs.put('loginName', email);

  String get loginPhone => prefs.get('loginPhone', defaultValue: '') as String;
  set loginPhone(String? phone) => prefs.put('loginPhone', phone);

  bool get showPerformanceOverlay =>
      prefs.get('perfOverlay', defaultValue: false) as bool;

  set showPerformanceOverlay(bool? value) {
    if (showPerformanceOverlay != value) {
      prefs.put('perfOverlay', value);
    }
  }

  // tooltips
  bool get disableTooltips =>
      prefs.get('disableTooltips', defaultValue: false) as bool;
  set disableTooltips(bool? flag) => prefs.put('disableTooltips', flag);

  bool get showCheckerboardImages =>
      prefs.get('checkerboardImages', defaultValue: false) as bool;

  set showCheckerboardImages(bool? value) {
    if (showCheckerboardImages != value) {
      prefs.put('checkerboardImages', value);
    }
  }

  bool get showCheckerboardLayers =>
      prefs.get('checkerboardLayers', defaultValue: false) as bool;

  set showCheckerboardLayers(bool? value) {
    if (showCheckerboardLayers != value) {
      prefs.put('checkerboardLayers', value);
    }
  }

  List<String> getFavoriteGoogleFonts() => List<String>.from(
        prefs.get('favoriteGoogleFonts', defaultValue: <String>[]) as List,
      );

  void setFavoriteGoogleFonts(List<String> value) {
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
      final jsonList = List<Map<dynamic, dynamic>>.from(pref as List);

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
      final List<Map<dynamic, dynamic>> maps =
          newThemes.map((x) => x.toMap()).toList();

      prefs.put('themeSets', maps);
    }
  }

  List<ServerFile> get favorites {
    final dynamic pref = prefs.get('favorites');

    if (pref != null) {
      final jsonList = List<Map<dynamic, dynamic>>.from(pref as List);

      return jsonList
          .map(
            (jsonMap) => ServerFile.fromMap(Map<String, dynamic>.from(jsonMap)),
          )
          .toList();
    }

    return [];
  }

  // pass null to delete
  set favorites(List<ServerFile>? favs) {
    if (favs == null) {
      prefs.delete('favorites');
    } else {
      final List<Map<dynamic, dynamic>> maps =
          favs.map((x) => x.toMap()).toList();

      prefs.put('favorites', maps);
    }
  }

  // ========================================================
  //  generic

  // --------------
  // boolPref
  bool boolPref({
    required String key,
    bool defaultValue = false,
  }) =>
      prefs.get(key, defaultValue: defaultValue) as bool;
  Future<void> setBoolPref({
    required String key,
    required bool? flag,
  }) =>
      prefs.put(key, flag);

  // --------------
  // intPref

  int intPref({
    required String key,
    int defaultValue = 0,
  }) =>
      prefs.get(key, defaultValue: defaultValue) as int;
  Future<void> setIntPref({
    required String key,
    required int? value,
  }) =>
      prefs.put(key, value);

  // --------------
  // stringPref
  String stringPref({
    required String key,
    String defaultValue = '',
  }) =>
      prefs.get(key, defaultValue: defaultValue) as String;
  Future<void> setStringPref({
    required String key,
    required String? value,
  }) =>
      prefs.put(key, value);

  // --------------
  // mapPref
  Map<String, dynamic> mapPref({
    required String key,
    Map<String, dynamic> defaultValue = const {},
  }) =>
      prefs.get(key, defaultValue: defaultValue) as Map<String, dynamic>;
  Future<void> setMapPref({
    required String key,
    required Map<String, dynamic>? value,
  }) =>
      prefs.put('$key-Map', value);

  // --------------
  // listPref
  List<T> listPref<T>({
    required String key,
    List<T> defaultValue = const [],
  }) {
    final result = prefs.get(key, defaultValue: defaultValue) as List;

    // hive sucks, I was getting back List<LinkedMap> which wasn't castable?
    // so I had to add this json convert
    final jstr = json.encode(result);
    final converted = json.decode(jstr) as List;

    return List<T>.from(converted);
  }

  Future<void> setListPref<T>({
    required String key,
    required List<T> value,
  }) =>
      prefs.put(key, value);
}

// ===================================================================
class PreferencesListener extends StatefulWidget {
  const PreferencesListener({
    required this.builder,
    required this.keys,
  });

  final Widget Function(BuildContext context) builder;

  final List<String> keys;

  @override
  State<PreferencesListener> createState() => _PreferencesListenerState();
}

class _PreferencesListenerState extends State<PreferencesListener> {
  late ValueListenable<Box<dynamic>> _listenable;
  final _updater = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _listenable = HiveBox.prefsBox.listenable(
      keys: widget.keys.isEmpty ? null : widget.keys,
    )!;

    _listenable.addListener(listener);
  }

  @override
  void dispose() {
    _listenable.removeListener(listener);

    super.dispose();
  }

  void listener() {
    // debounce this
    _updater.run(
      () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: HiveBox.prefsBox.listenable(
        keys: widget.keys.isEmpty ? null : widget.keys,
      )!,
      builder: (BuildContext context, Box<dynamic> prefsBox, Widget? _) {
        return widget.builder(context);
      },
    );
  }
}
