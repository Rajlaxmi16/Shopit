import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories.dart';
import 'profile.dart';
import 'cart.dart';
import '../data/cart_data.dart'; 

class ShopitScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const ShopitScaffold({
    Key? key,
    required this.body,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<ShopitScaffold> createState() => _ShopitScaffoldState();
}

class _ShopitScaffoldState extends State<ShopitScaffold> {
  void _onTap(int index) {
    if (index == widget.currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = ShopitHome();
        break;
      case 1:
        destination = CategoriesScreen();
        break;
      case 2:
        destination = CartScreen();
        break;
      case 3:
        destination = ProfileScreen();
        break;
      default:
        destination = ShopitHome();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  int getTotalCartQuantity() {
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.currentIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ShopitHome()),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: widget.body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: _onTap,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (getTotalCartQuantity() > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${getTotalCartQuantity()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Cart',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}


