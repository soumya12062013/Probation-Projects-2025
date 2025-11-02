import 'dart:async';
import 'package:flutter/material.dart';
import 'onboadingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoadingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Images/bg_img.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white30.withOpacity(0.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Agrisense',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 36, 115, 38),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                    fontSize: 40,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
