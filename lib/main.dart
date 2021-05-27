import 'package:flutter/material.dart';
import 'package:health_care/MainScreen/main_screen.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Care',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: bgColor,
      ),

      home: MainScreen(),
    );
  }
}


