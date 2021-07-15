extension MapCasting on Map {
  // casts dynamic value to String
  // returns '' on failure or null
  String strVal(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return '';
    }

    if (result is String) {
      return result;
    } else {
      print('strVal: not string $result');
    }

    return '';
  }

  Map<K, V>? mapVal<K, V>(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return null;
    }

    if (result is Map) {
      Map mapResult = result;

      if (mapResult is! Map<K, V>) {
        mapResult = Map<K, V>.from(mapResult);
      }
      return mapResult;
    } else {
      print('mapVal: not map $result');
    }

    return null;
  }

  double doubleVal(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return 0.0;
    }

    if (result is double) {
      return result;
    } else {
      print('double: not double $result');
    }

    return 0.0;
  }

  int intVal(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return 0;
    }

    if (result is int) {
      return result;
    } else {
      print('intV: not int $result');
    }

    return 0;
  }

  bool boolVal(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return false;
    }

    if (result is bool) {
      return result;
    } else {
      print('boolVal: not bool $result');
    }

    return false;
  }

  List<T>? listVal<T>(String key) {
    final dynamic result = this[key];

    if (result == null) {
      return null;
    }

    if (result is List) {
      List listResult = result;

      if (listResult is! List<T>) {
        listResult = List<T>.from(listResult);
      }
      return listResult;
    } else {
      print('listVal: not List $result');
    }

    return null;
  }

  dynamic findValueForKey(String key) {
    return _findValueForKey(this as Map<String, dynamic>, key);
  }

  dynamic _findValueForKey(Map<String, dynamic> map, String matchKey) {
    dynamic result;

    for (final key in map.keys) {
      final dynamic value = map[key];

      if (matchKey == key) {
        return value;
      }

      if (value is Map<String, dynamic>) {
        result = _findValueForKey(value, key);
      } else if (value is List) {
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            result = _findValueForKey(item, key);

            if (result != null) {
              return value;
            }
          }
        }
      }
    }

    return null;
  }
}
