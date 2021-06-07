import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/MainScreen/main_screen.dart';
import 'package:health_care/home_screen.dart';
import 'package:health_care/service/auth.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null)
            return SignInScreen(
              auth: auth,

            );
          return MainScreen(
            auth: auth,

          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );

  }
}
