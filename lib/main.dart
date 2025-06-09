import 'package:flutter/material.dart';
import '/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/home_screen.dart';
import '/screens/login.dart';
import 'services/transition.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51RWu6CRtj3vJEaAcFBZqOMqk1Yk5npH4kBNQHYLKNpaUkmEd1ilMHnZehb02KYtQDE3CbCD7EgTtopvLKomYA4no008ImGeQJQ'; 

  Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecom',
      theme: ThemeData(       
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFCA28)),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomTransitionBuilder(),
            TargetPlatform.iOS: CustomTransitionBuilder(),
          },
        ),
      ),
      home: SplashScreen(),
    );
  }
}




