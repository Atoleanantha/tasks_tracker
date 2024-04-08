
import 'dart:ui';

import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = {};
  final r = color.red, g = color.green, b = color.blue;

  for (var strength in strengths) {
    swatch[strength] = Color.fromRGBO(r, g, b, strength / 900);
  }

  return MaterialColor(color.value, swatch);
}