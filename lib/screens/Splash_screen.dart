import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home_screen.dart';
import 'Login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    check_login();
  }

  void check_login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isloggedin = prefs.getBool('isloggedin') ?? false;
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) return;
    if (isloggedin) {
      Navigator.pushReplacementNamed(context, 'HomeScreen');
    } else {
      Navigator.pushReplacementNamed(context, 'LoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.2, end: 1.0),
                duration: Duration(seconds: 3),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Image.asset(
                  "assets/images/Gemini_Generated_Image_7o5p9t7o5p9t7o5p-removebg-preview.png",
                  height: 200,
                  width: 200,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Brain Lab',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
