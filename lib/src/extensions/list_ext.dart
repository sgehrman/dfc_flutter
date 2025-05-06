import 'package:flutter/material.dart';

extension ExtendedList on List<Widget> {
  List<Widget> addDividers({Widget divider = const Divider(height: 6)}) {
    final result = <Widget>[];

    if (length < 2) {
      return this;
    }

    for (var i = 0; i < length; i++) {
      result.add(this[i]);

      if (i < length - 1) {
        result.add(divider);
      }
    }

    return result;
  }
}

extension GenericList<T> on List<T> {
  List<T> truncate(int limit) {
    if (length > limit) {
      return sublist(0, limit);
    }

    return this;
  }

  int validIndex(int index) {
    if (isEmpty) {
      print('### validIndex() error: List is empty, index: $index');
    }

    if (index < 0) {
      return 0;
    } else if (index >= length) {
      return length - 1;
    }

    return index;
  }
}
