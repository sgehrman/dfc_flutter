import 'package:flutter/material.dart';

extension ExtendedList on List {
  List<Widget> addDividers() {
    final List<Widget> result = [];

    if (length < 2) {
      return this as List<Widget>;
    }

    for (int i = 0; i < length; i++) {
      result.add(this[i] as Widget);

      if (i < length - 1) {
        result.add(const Divider(height: 6));
      }
    }

    return result;
  }
}
