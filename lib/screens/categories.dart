import 'package:ecom_app/screens/shopit_scaffold.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ShopitScaffold(
        currentIndex: 1,
        body: Center(child: Text('Categories', style: TextStyle(fontSize: 24))),
      );
}