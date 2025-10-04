import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
       title: Text(
        'Brain Lab',
       style:TextStyle(
        fontSize:34,
        fontWeight:FontWeight.bold,
       )
       ),
      ),
      body: Center(
        child:Form(
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Container(
              child: Text(
                'Login to your Account',
                style:TextStyle(
                  fontSize:28,
                  fontWeight:FontWeight.bold,
                  color: Color(0xFF2980B9),
                )
                )
            ),
            SizedBox(height: 50,),
            
          
        ],)
      )
      )
    
    );
  }
}