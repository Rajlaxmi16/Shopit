import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'cart.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailPage({required this.product, super.key});
  void toCart(BuildContext context) {
     cartItems.add(
      CartItem(
        name: product['name'],
        price: product['price'],
        image: product['image'],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart")));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Color(0xFFFFCA28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(product['image'], height: 200),
            ),
            SizedBox(height: 20),
            Text(product['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('₹${product['price']}', style: TextStyle(fontSize: 20, color: Colors.teal)),
            SizedBox(height: 16),
            Text(product['description'], style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(              
              onPressed: () {
                toCart(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text("Add to Cart"),
            ),
            ),
            
          ],
        ),
      ),
    );
  }
}
