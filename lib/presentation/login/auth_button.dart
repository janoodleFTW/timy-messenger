import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class AuthButton extends StatelessWidget {
  final String buttonText;
  final Function onPressedCallback;

  const AuthButton({
    @required this.buttonText,
    this.onPressedCallback
  });

  @override 
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressedCallback,
      color: Colors.blue,
      child: Container(
        height: 50.0,
        alignment: Alignment.center,
        child: Text(
          buttonText, 
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white)
        )
      ),
    );
  }
}
