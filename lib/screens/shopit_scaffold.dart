import 'package:ecom_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'categories.dart';
import 'profile.dart';
import 'cart.dart';

class ShopitScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const ShopitScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination =  ShopitHome();
        break;
      case 1:
        destination =  CategoriesScreen();
        break;
      case 2:
        destination =  CartScreen();
        break;
      case 3:
        destination =  ProfileScreen();
        break;
      default:
        destination =  ShopitHome();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ShopitHome()),
          );
          return false; 
        }
        return true; 
      },
    child:  Scaffold(
     backgroundColor:  Colors.white,
      appBar: AppBar(
        title: Text(
          'Shopit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 203, 17, 17),
          ), 
        ),
        backgroundColor: Color(0xFFFFCA28),
        shadowColor: Colors.blueGrey,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor : Colors.white ,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ),
    );
  }
}
