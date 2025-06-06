import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'cart.dart';

class ProductDetailPage extends StatelessWidget {
  //final Map<String, dynamic> product;
  final CartItem product;

  const ProductDetailPage({required this.product, super.key});

  void toCart(BuildContext context) {
  final existingItem = cartItems.firstWhere(
    (item) => item.name == product.name, //product['name']
    orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
  );

  if (existingItem.name != '') {
    
    existingItem.quantity++;
  } else {
    
    cartItems.add(
      CartItem(
        name: product.name,//product['name']
        price: product.price,//product['price']
        image: product.image,//product['image']
        quantity: 1,
      ),
    );
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Added to cart")),
  );

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => CartScreen()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'No Name'), //Text(product['name']),
        backgroundColor: Color(0xFFFFCA28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(product.image ?? 'assets/app_icon.png', height: 200,),//product['image'], height: 200),
            ),
            SizedBox(height: 20),
            Text(product.name ?? 'No Name', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), //product['name']
            SizedBox(height: 8),
            Text('₹${product.price ?? 0}', style: TextStyle(fontSize: 20, color: Colors.teal)), //'₹${product['price']}',
            SizedBox(height: 16),
            //Text(product.description ?? 'No description available', style: TextStyle(fontSize: 16)), //product['description'],
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => toCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(    
                      borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';
// import 'cart.dart';

// class ProductDetailPage extends StatelessWidget {
//   final Map<String, dynamic> product;
//   const ProductDetailPage({required this.product, super.key});
//   void toCart(BuildContext context) {
//      cartItems.add(
//       CartItem(
//         name: product['name'],
//         price: product['price'],
//         image: product['image'],
//       ),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to cart")));
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CartScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['name']),
//         backgroundColor: Color(0xFFFFCA28),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: Image.asset(product['image'], height: 200),
//             ),
//             SizedBox(height: 20),
//             Text(product['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text('₹${product['price']}', style: TextStyle(fontSize: 20, color: Colors.teal)),
//             SizedBox(height: 16),
//             Text(product['description'], style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(              
//               onPressed: () {
//                 toCart(context);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//               child: Text("Add to Cart"),
//             ),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }
