import 'package:ecom_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ShopitHome()),
        );
      } else {
        // User not logged in
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (_) => LoginScreen()),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFCA28),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Image.asset(
              'assets/banner/splash_banner.png', 
              width: double.infinity,
              
              fit: BoxFit.cover,
              
            ),
            // Image.asset(
            //   'assets/app_icon.png', 
            //   width: 150,
            //   height: 150,
              
            // ),
            SizedBox(height: 5),
            Text(
              'Shopit',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 72, 72),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Click. Shopit. Repeat.',
              style: TextStyle(
                fontSize: 24,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 75, 72, 72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}