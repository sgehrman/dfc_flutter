import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color mix(Color another, double amount) =>
      Color.lerp(this, another, amount) ?? Colors.red;
}
