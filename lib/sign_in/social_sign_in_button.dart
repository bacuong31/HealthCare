import 'package:flutter/cupertino.dart';
import 'package:health_care/button/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    String assetName,
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(assetName),
        Text(
          text,
          style: TextStyle(color: textColor, fontSize: 18.0),
        ),
        Opacity(opacity: 0.0, child: Image.asset(assetName)),
      ],
    ),
    color: color,
    onPressed: onPressed,
  );
}
