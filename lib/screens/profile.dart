import 'package:flutter/material.dart';
import 'shopit_scaffold.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/screens/login.dart';

class ProfileScreen extends StatelessWidget {
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) => ShopitScaffold(
        
        currentIndex: 3,
        body: Center(
        child: ElevatedButton.icon(
          onPressed: () => logout(context),
          icon: Icon(Icons.logout),
          label: Text("Logout"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      );
}