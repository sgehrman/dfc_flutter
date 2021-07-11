import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBox<T> {
  HiveBox._(this.name);

  factory HiveBox.box(String boxName) {
    return HiveBox<T>._(boxName);
  }

  // static access to the prefs box
  static HiveBox<dynamic> get prefsBox => _prefs;
  static final HiveBox<dynamic> _prefs = HiveBox<dynamic>.box('prefs');

  String name;
  int _refCount = 0;
  Box<T>? _box;

  ValueListenable<Box<T>>? listenable() {
    assert(_box != null, 'Box is closed: $name');

    return _box?.listenable();
  }

  // open first or it will crash
  Future<void> open() async {
    _refCount++;

    if (_refCount == 1) {
      _box = await Hive.openBox<T>(name);
    }
  }

  Future<void> close() async {
    if (_box == null) {
      // already closed
      return;
    }

    _refCount--;

    if (_refCount == 0) {
      await _box?.close();

      _box = null;
    }
  }

  int? get length {
    assert(_box != null, 'Box is closed: $name');

    return _box?.length;
  }

  void add(T data) {
    assert(_box != null, 'Box is closed: $name');

    _box?.add(data);
  }

  T? getAt(int index) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.getAt(index);
  }

  Future<void>? put(String key, T data) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.put(key, data);
  }

  T? get(String key, {T? defaultValue}) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.get(key, defaultValue: defaultValue);
  }

  List<T>? getAll() {
    assert(_box != null, 'Box is closed: $name');

    return _box?.values.toList();
  }

  Future<void>? deleteAt(int index) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.deleteAt(index);
  }

  Future<int?> clear() async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.clear();
  }

  Future<void>? delete(String key) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.delete(key);
  }
}
