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
     backgroundColor:  const Color.fromARGB(255, 221, 244, 243),
      appBar: AppBar(
        title: Text(
          'Shopit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 46, 92, 171),
          ), 
        ),
        backgroundColor: const Color.fromARGB(255, 153, 236, 232),
        shadowColor: Colors.blueGrey,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color.fromARGB(255, 153, 236, 232),
        selectedItemColor: const Color.fromARGB(255, 46, 92, 171),
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
