import 'package:ecom_app/screens/shopit_scaffold.dart';
import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeItem(int index) {
    setState(() {
      if (index >= 0 && index < cartItems.length) {
        setState(() {
        cartItems.removeAt(index);
      });
      }
    });
  }
  void toHome(BuildContext context){
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ShopitHome()),
          );
  }
  @override
  Widget build(BuildContext context) {
    int total = cartItems.fold(0, (sum, item) => sum + item.price);

    return ShopitScaffold(
      currentIndex: 2,
      body: cartItems.isEmpty
          ? Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
              'assets/empty_cart.png', 
              width: 200,
              height: 250,
              ),
              SizedBox(height: 5),
              Text(
                'Oops! Your cart is empty.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 107, 104, 104),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () => toHome(context),
                 child: Text(
                  'Shop Now',                  
                 ))
            ],
          ),)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      if (index < 0 || index >= cartItems.length) {
                        return SizedBox(); 
                      }
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.asset(item.image, width: 50, height: 50),
                          title: Text(item.name),
                          subtitle: Text("₹${item.price}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Total: ₹$total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}
