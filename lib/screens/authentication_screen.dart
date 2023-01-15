import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:snapchat_filters/widgets/auth_button.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 100),
          Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logo.png'),
            height: 160,
          ),
          SizedBox(
            height: 2,
          ),
      Positioned(
          bottom: 40,
          child:Container(
            padding:EdgeInsets.fromLTRB(20,0,20,0),
            margin: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(

                 child:Text( "LOG IN"),

                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
            style: ElevatedButton.styleFrom(
                shape:
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),

                  ),
                 minimumSize: Size(120, 55),//<-- SEE HERE
                backgroundColor: Colors.blue,
              shadowColor: Colors.blueAccent,
              elevation: 3,
                )),
                ElevatedButton(
                  child:Text( "SIGN UP"),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()));
                  },
                    style: ElevatedButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(120, 55),//<-- SEE HERE
                      backgroundColor: Colors.blue,
                      shadowColor: Colors.blueAccent,
                      elevation: 3,
                    )
                ),
              ],
            ),
          )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}