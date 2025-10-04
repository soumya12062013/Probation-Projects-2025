import 'package:flutter/material.dart';
import 'package:quiz_app/screens/Splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: 'SplashScreen',
      debugShowCheckedModeBanner: false,
      routes: {'SplashScreen': (context) => SplashScreen()},
    ),
  );
}
