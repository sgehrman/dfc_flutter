import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends ChangeNotifier {
  factory Settings() {
    return _instance ??= Settings._();
  }
  Settings._();
  static Settings? _instance;
  String _keyChanged = '';
  bool _initialized = false;

  late SharedPreferencesWithCache _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    _initialized = true;
  }

  String get keyChanged => _keyChanged;

  void _check() {
    if (!_initialized) {
      print('Error: Settings not initialized');
    }
  }

  // ---------------------------------------------------
  // getters

  bool boolValue(
    String key, {
    required bool defaultValue,
  }) {
    _check();

    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  int intValue(
    String key, {
    required int defaultValue,
  }) {
    _check();

    return _sharedPreferences.getInt(key) ?? defaultValue;
  }

  List<String> listValue(
    String key, {
    required List<String> defaultValue,
  }) {
    _check();

    return _sharedPreferences.getStringList(key) ?? defaultValue;
  }

  String stringValue(
    String key, {
    required String defaultValue,
  }) {
    _check();

    return _sharedPreferences.getString(key) ?? defaultValue;
  }

  double doubleValue(
    String key, {
    required double defaultValue,
  }) {
    _check();

    return _sharedPreferences.getDouble(key) ?? defaultValue;
  }

  // ---------------------------------------------------
  // setters

  void _notifyListeners(String key) {
    _keyChanged = key;
    notifyListeners();
    _keyChanged = '';
  }

  void setBool(
    String key, {
    required bool value,
  }) {
    _check();

    _sharedPreferences.setBool(key, value);

    _notifyListeners(key);
  }

  void setInt(
    String key, {
    required int value,
  }) {
    _check();

    _sharedPreferences.setInt(key, value);

    _notifyListeners(key);
  }

  void setList(
    String key, {
    required List<String> value,
  }) {
    _check();

    _sharedPreferences.setStringList(key, value);

    _notifyListeners(key);
  }

  void setString(
    String key, {
    required String value,
  }) {
    _check();

    _sharedPreferences.setString(key, value);

    _notifyListeners(key);
  }

  void setDouble(
    String key, {
    required double value,
  }) {
    _check();

    _sharedPreferences.setDouble(key, value);

    _notifyListeners(key);
  }
}

// ======================================================================

class SettingsListener extends StatefulWidget {
  const SettingsListener({
    required this.builder,
    required this.keys,
  });

  final Widget Function(BuildContext context) builder;
  final List<String> keys;

  @override
  State<SettingsListener> createState() => _SettingsListenerState();
}

class _SettingsListenerState extends State<SettingsListener> {
  @override
  void initState() {
    super.initState();

    Settings().addListener(listener);
  }

  @override
  void dispose() {
    Settings().removeListener(listener);

    super.dispose();
  }

  void listener() {
    if (widget.keys.contains(Settings().keyChanged)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
