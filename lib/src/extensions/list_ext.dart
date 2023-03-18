import 'package:flutter/material.dart';

extension ExtendedList on List<dynamic> {
  List<Widget> addDividers({Widget divider = const Divider(height: 6)}) {
    final List<Widget> result = [];

    if (length < 2) {
      return this as List<Widget>;
    }

    for (int i = 0; i < length; i++) {
      result.add(this[i] as Widget);

      if (i < length - 1) {
        result.add(divider);
      }
    }

    return result;
  }
}
