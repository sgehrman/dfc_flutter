import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Common {
  const Common();

  static Future<void> storageSet(String key, String value) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setString(key, value);
  }

  static Future<void> storageRemove(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.remove(key);
  }

  static Future<String?> storageGet(String key) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  static String toJson(dynamic object) {
    const encoder = JsonEncoder.withIndent('     ');
    return encoder.convert(object);
  }

  static dynamic fromJson(String jsonString) {
    return json.decode(jsonString);
  }

  static bool hasKeyIgnoreCase(Map map, String key) {
    return map.keys.any((dynamic x) => equalsIgnoreCase(x as String, key));
  }

  static String encodeMap(Map data) {
    return data.keys.map<String>((dynamic key) {
      final k = Uri.encodeComponent(key.toString());
      final v = Uri.encodeComponent(data[key].toString());
      return '$k=$v';
    }).join('&');
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
