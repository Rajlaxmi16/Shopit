import 'package:flutter/material.dart';
import 'shopit_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ShopitScaffold(
        
        currentIndex: 3,
        body: Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
      );
}