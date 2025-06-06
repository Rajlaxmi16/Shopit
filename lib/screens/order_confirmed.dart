import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import 'dart:async';


class OrderConfiremed extends StatefulWidget {
  @override
  _OrderConfiremed createState() => _OrderConfiremed();
}

class _OrderConfiremed extends State<OrderConfiremed> {
  @override
  void initState() {
    super.initState();

    
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ShopitHome()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/order_confirmed.png', 
              width: 150,
              height: 150,
              
            ),
            SizedBox(height: 5),
            Text(
              'Order Confirmed',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}