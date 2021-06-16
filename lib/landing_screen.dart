import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/MainScreen/main_screen.dart';
import 'package:health_care/home_screen.dart';
import 'package:health_care/service/auth.dart';
import 'package:health_care/sign_in/sign_in_screen.dart';
var ref = FirebaseFirestore.instance.collection('users');

class LandingScreen extends StatelessWidget {
  LandingScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user != null){
            _createUserIfNotExist(user);
            return MainScreen(
              auth: auth,
            );
          }

          return SignInScreen(
            auth: auth,
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );

  }
  Future<void> _createUserIfNotExist(User user) async{
    ref.doc(user.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists){
        ref.add({
          'id': user.uid,
          'full name': "Chưa cập nhật",
          'phone number': "",
          'image profile': "",
          'sex' : "Chưa cập nhật",
        });
      }
    });
  }
}
