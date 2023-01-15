import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapchat_filters/routes.dart';
import 'package:snapchat_filters/screens/authentication_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticationScreen(),
      routes:Routes,
    );
  }
}
