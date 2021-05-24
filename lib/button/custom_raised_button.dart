


import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  final double height;
  CustomRaisedButton({this.child,this.color,this.height : 50,this.borderRadius : 16.0,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        onPressed: onPressed,
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            )
        ),
      ),
    );
  }
}
