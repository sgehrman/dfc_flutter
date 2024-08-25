import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// unused for now
// do this at HiveInit or somewhere called in main()
// await Settings().initialize();

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

  bool boolValue({
    required String key,
    bool defaultValue = false,
  }) {
    _check();

    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  int intValue({
    required String key,
    int defaultValue = 0,
  }) {
    _check();

    return _sharedPreferences.getInt(key) ?? defaultValue;
  }

  List<String> listValue({
    required String key,
    List<String> defaultValue = const [],
  }) {
    _check();

    return _sharedPreferences.getStringList(key) ?? defaultValue;
  }

  String stringValue({
    required String key,
    String defaultValue = '',
  }) {
    _check();

    return _sharedPreferences.getString(key) ?? defaultValue;
  }

  double doubleValue({
    required String key,
    double defaultValue = 0,
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

  void setBool({
    required String key,
    required bool value,
  }) {
    _check();

    _sharedPreferences.setBool(key, value);

    _notifyListeners(key);
  }

  void setInt({
    required String key,
    required int value,
  }) {
    _check();

    _sharedPreferences.setInt(key, value);

    _notifyListeners(key);
  }

  void setList({
    required String key,
    required List<String> value,
  }) {
    _check();

    _sharedPreferences.setStringList(key, value);

    _notifyListeners(key);
  }

  void setString({
    required String key,
    required String value,
  }) {
    _check();

    _sharedPreferences.setString(key, value);

    _notifyListeners(key);
  }

  void setDouble({
    required String key,
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
