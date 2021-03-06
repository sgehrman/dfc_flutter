import 'package:flutter/foundation.dart';
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

  ValueListenable<Box<T>>? listenable({
    List<String>? keys,
  }) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.listenable(keys: keys);
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

  bool containsKey(Object key) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.containsKey(key) ?? false;
  }

  int get length {
    assert(_box != null, 'Box is closed: $name');

    return _box?.length ?? 0;
  }

  Future<void> add(T data) async {
    assert(_box != null, 'Box is closed: $name');

    await _box?.add(data);
  }

  Future<void> addAll(List<T> data) async {
    assert(_box != null, 'Box is closed: $name');

    await _box?.addAll(data);
  }

  Future<void> put(Object key, T data) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.put(key, data);
  }

  T? get(Object key, {T? defaultValue}) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.get(key, defaultValue: defaultValue);
  }

  List<T> getAll() {
    assert(_box != null, 'Box is closed: $name');

    return _box?.values.toList() ?? [];
  }

  Future<int> clear() async {
    assert(_box != null, 'Box is closed: $name');

    return _box != null ? (await _box!.clear()) : 0;
  }

  Future<void> delete(Object key) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.delete(key);
  }

  // ------------------------------------
  // by index

  Future<void> putAt(int index, T data) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.putAt(index, data);
  }

  T? getAt(int index) {
    assert(_box != null, 'Box is closed: $name');

    return _box?.getAt(index);
  }

  Future<void> deleteAt(int index) async {
    assert(_box != null, 'Box is closed: $name');

    return _box?.deleteAt(index);
  }
}
