import 'package:flutter/material.dart';
import '/screens/login.dart';
import 'dart:async';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 244, 243),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_icon.png', 
              width: 150,
              height: 150,
            ),
            SizedBox(height: 5),
            Text(
              'Shopit',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 46, 92, 171),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Click. Shopit. Repeat.',
              style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 57, 106, 191),
              ),
            ),
          ],
        ),
      ),
    );
  }
}