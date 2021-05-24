import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_care/button/custom_raised_button.dart';
import 'package:health_care/sign_in/sign_in_button.dart';
import 'package:health_care/sign_in/social_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Care'),
        centerTitle: true,
        elevation: 15.0,
      ),
      body: _buildContainer(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SocialSignInButton(
            assetName: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            onPressed: () {},
            color: Colors.white,
          ),
          SizedBox(
            height: 15,
          ),
          SignInButton(
            assetName: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            onPressed: () {},
            color: Color(0xff334d92),
          ),
          SizedBox(
            height: 15,
          ),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            onPressed: () {},
            color: Color(0xdb709988),
          ),
        ],
      ),
    );
  }
}
