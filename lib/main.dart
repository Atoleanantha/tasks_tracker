import 'package:flutter/material.dart';
import 'package:task_tracker/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: createMaterialColor(Color(0xFF384358)),
        backgroundColor: const Color(0xFF384358),
      ),
      home:const HomeScreen(),
    );
  }
}
MaterialColor createMaterialColor(Color color) {
  List<int> strengths = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
  Map<int, Color> swatch = {};
  final r = color.red, g = color.green, b = color.blue;

  for (var strength in strengths) {
    swatch[strength] = Color.fromRGBO(r, g, b, strength / 900);
  }

  return MaterialColor(color.value, swatch);
}