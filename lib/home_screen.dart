import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/service/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async{
    try{
      await auth.signOut();

    } catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Health Care',
            style: TextStyle(fontSize: 18.0),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: _signOut,
                child: Text('Log out', style: TextStyle(fontSize: 18.0)))
          ]),
    );
  }
}
