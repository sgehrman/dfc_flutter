import 'package:flutter/material.dart';

class NextColor {
  int _colorIndex = 0;

  static final _colors = <Color>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
    Colors.orange,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.lime,
    Colors.yellow,
    Colors.blueGrey,
    Colors.brown,
  ];

  static final _darkColors = <Color>[
    Colors.red[900] ?? Colors.black,
    Colors.pink[900] ?? Colors.black,
    Colors.purple[900] ?? Colors.black,
    Colors.indigo[900] ?? Colors.black,
    Colors.cyan[900] ?? Colors.black,
    Colors.green[900] ?? Colors.black,
    Colors.orange[900] ?? Colors.black,
    Colors.teal[900] ?? Colors.black,
    Colors.amber[900] ?? Colors.black,
    Colors.indigo[900] ?? Colors.black,
    Colors.lime[900] ?? Colors.black,
    Colors.yellow[900] ?? Colors.black,
    Colors.blueGrey[900] ?? Colors.black,
    Colors.brown[900] ?? Colors.black,
  ];

  Color color() {
    return _nextColor(useDark: false);
  }

  Color darkColor() {
    return _nextColor(useDark: true);
  }

  static Color colorForIndex(int index) {
    return _colorForIndex(useDark: false, index: index);
  }

  static Color darkColorForIndex(int index) {
    return _colorForIndex(useDark: true, index: index);
  }

  // =============================================
  // private

  static Color _colorForIndex({required bool useDark, required int index}) {
    if (useDark) {
      return _darkColors[index % _darkColors.length];
    }

    return _colors[index % _colors.length];
  }

  Color _nextColor({required bool useDark}) {
    return _colorForIndex(useDark: useDark, index: _colorIndex++);
  }
}
