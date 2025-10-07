import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Splash_screen.dart';
import 'package:quiz_app/screens/Login_screen.dart';
import 'package:quiz_app/screens/Createacc_screen.dart';
import 'package:quiz_app/screens/Home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: 'SplashScreen',
      debugShowCheckedModeBanner: false,
      routes: {
        'SplashScreen': (context) => SplashScreen(),
        'LoginScreen': (context) => LoginScreen(),
        'CreateAccScreen': (context) => CreateAccScreen(),
        'HomeScreen': (context) => HomeScreen(),
      },
    ),
  );
}
