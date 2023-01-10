import 'package:flutter/material.dart';

class LoginAndSignUpButton extends StatelessWidget {
  final Color color;
  final Function onPress;
  final String text;

  LoginAndSignUpButton({
    required this.color,
    required this.onPress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        height: 55,
        width: 260,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
        ),
      ),
    );
  }
}