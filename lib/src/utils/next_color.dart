import 'package:flutter/material.dart';

class NextColor {
  int _colorIndex = 0;

  final _colors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
    Colors.orange,
  ];

  final _darkColors = <Color>[
    Colors.red[900] ?? Colors.black,
    Colors.pink[900] ?? Colors.black,
    Colors.purple[900] ?? Colors.black,
    Colors.indigo[900] ?? Colors.black,
    Colors.cyan[900] ?? Colors.black,
    Colors.green[900] ?? Colors.black,
    Colors.orange[900] ?? Colors.black,
  ];

  int _nextIndex(bool useDark) {
    final length = useDark ? _darkColors.length : _colors.length;

    if (_colorIndex >= length) {
      _colorIndex = 0;
    }

    return _colorIndex++;
  }

  Color color() {
    return _colors[_nextIndex(false)];
  }

  Color darkColor() {
    return _darkColors[_nextIndex(true)];
  }
}
