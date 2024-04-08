import 'package:flutter/material.dart';
import 'package:task_tracker/screens/home/home_screen.dart';
import 'package:task_tracker/utils/colors.dart';

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
