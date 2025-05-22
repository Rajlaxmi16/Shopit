import 'package:ecom_app/screens/home_screen.dart';
import 'package:ecom_app/screens/shopit_scaffold.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  void toHome(BuildContext context){
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ShopitHome()),
          );
  }
  @override
  Widget build(BuildContext context) => ShopitScaffold(
        currentIndex: 2,
        body: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
              'assets/empty_cart.png', 
              width: 150,
              height: 150,
              ),
              ElevatedButton(
                onPressed: () => toHome(context),
                 child: Text(
                  'Shop Now',                  
                 ))
            ],
          ),
        )
        
  );
}