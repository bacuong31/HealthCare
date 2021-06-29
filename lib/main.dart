import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:health_care/landing_screen.dart';
import 'package:health_care/model/AppUser.dart';
import 'package:health_care/service/auth.dart';

import 'package:health_care/MainScreen/main_screen.dart';
import 'package:health_care/constants.dart';

import 'package:health_care/sign_in/sign_in_screen.dart';


AppUser currentUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
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

      home: LandingScreen(
        auth: Auth(),
      ),

    );
  }
}


