import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatefulWidget {
  final CartItem product;

  const ProductDetailPage({required this.product, super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfWishlisted();
  }

  Future<void> toggleWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to add to wishlist')));
      return;
    }

    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(widget.product.name);

    final doc = await wishlistRef.get();

    if (doc.exists) {
      await wishlistRef.delete();
      setState(() => isFavorite = false);
    } else {
      await wishlistRef.set({
        'name': widget.product.name,
        'price': widget.product.price,
        'image': widget.product.image,
        'description': widget.product.description ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() => isFavorite = true);
    }
  }

  Future<void> checkIfWishlisted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(widget.product.name)
          .get();
      if (doc.exists) setState(() => isFavorite = true);
    }
  }

  Future<void> addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to add to cart')));
      return;
    }

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(widget.product.name);

    await cartRef.set({
      'name': widget.product.name,
      'price': widget.product.price,
      'image': widget.product.image,
      'quantity': quantity,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optional local list update
    final index = cartItems.indexWhere((item) => item.name == widget.product.name);
    if (index != -1) {
      cartItems[index].quantity = quantity;
    } else {
      cartItems.add(CartItem(
        name: widget.product.name,
        price: widget.product.price,
        image: widget.product.image,
        quantity: quantity,
      ));
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Color(0xFFFFCA28),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                    ),
                  ),
                  IconButton(
                    onPressed: toggleWishlist,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '₹${widget.product.price}',
                  style: TextStyle(fontSize: 22, color: Colors.teal.shade700, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.product.description ?? 'No description available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: addToCart,
                      icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                      label: Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text('$quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';
// import 'cart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class ProductDetailPage extends StatefulWidget {
//   final CartItem product;

//   const ProductDetailPage({required this.product, super.key});

//   @override
//   State<ProductDetailPage> createState() => _ProductDetailPageState();
// }

// class _ProductDetailPageState extends State<ProductDetailPage> {
//   int quantity = 1;
//   bool isFavorite = false;
//   late CartItem cartItem;

//   Future<void> toggleWishlist() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to add to wishlist')));
//     return;
//   }

//   final wishlistRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('wishlist')
//       .doc(widget.product.name); 

//   final doc = await wishlistRef.get();

//   if (doc.exists) {
//     await wishlistRef.delete();
//     setState(() => isFavorite = false);
//   } else {
//     await wishlistRef.set({
//       'name': widget.product.name,
//       'price': widget.product.price,
//       'image': widget.product.image,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     setState(() => isFavorite = true);
//   }
// }
//   checkIfWishlisted() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('wishlist')
//           .doc(widget.product.name)
//           .get();

//       if (doc.exists) {
//         setState(() => isFavorite = true);
//       }
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     final existing = cartItems.firstWhere(
//     (item) => item.name == widget.product.name,
//     orElse: () => CartItem(
//       name: widget.product.name,
//       price: widget.product.price,
//       image: widget.product.image,
//       quantity: 1,
//     ),
//   );

//   cartItem = CartItem(
//     name: existing.name,
//     price: existing.price,
//     image: existing.image,
//     quantity: existing.quantity,
//   );
//     // final index = cartItems.indexWhere((item) => item.name == widget.product.name);
//     // if (index != -1) {
//     //   cartItem = cartItems[index];
//     // } else {
//     //   cartItem = CartItem(
//     //     name: widget.product.name,
//     //     price: widget.product.price,
//     //     image: widget.product.image,
//     //     quantity: 1,
//     //   );
//     //   cartItems.add(cartItem);
//     // }
//     // checkIfWishlisted();
//   }

//   void toCart(CartItem item) async {
//   final uid = FirebaseAuth.instance.currentUser?.uid;
//   if (uid == null) return;

//   final cartRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('cart')
//       .doc(item.name); // or item.id if available

//   await cartRef.set({
//     'name': item.name,
//     'price': item.price,
//     'image': item.image,
//     'quantity': item.quantity,
//   }, SetOptions(merge: true));
// }


// //   void toCart(BuildContext context) {
// //   final existingItem = cartItems.firstWhere(
// //     (item) => item.name == cartItem.name,
// //     orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
// //   );

// //   if (existingItem.name != '') {
// //     existingItem.quantity = cartItem.quantity;
// //   } else {
// //     cartItems.add(cartItem);
// //   }

// //   ScaffoldMessenger.of(context).showSnackBar(
// //     SnackBar(content: Text("Added ${cartItem.quantity} to cart")),
// //   );

// //   Navigator.push(
// //     context,
// //     MaterialPageRoute(builder: (_) => CartScreen()),
// //   );
// // }

  

//   // void toCart(BuildContext context) {
//   //   final existingItem = cartItems.firstWhere(
//   //     (item) => item.name == widget.product.name,
//   //     orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
//   //   );

//   //   if (existingItem.name != '') {
//   //     existingItem.quantity += quantity;
//   //   } else {
//   //     cartItems.add(
//   //       CartItem(
//   //         name: widget.product.name,
//   //         price: widget.product.price,
//   //         image: widget.product.image,
//   //         quantity: quantity,
//   //       ),
//   //     );
//   //   }

//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(content: Text("Added $quantity to cart")),
//   //   );

//   //   Navigator.push(
//   //     context,
//   //     MaterialPageRoute(builder: (_) => CartScreen()),
//   //   );
//   // }

//  @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.grey.shade100,
//     appBar: AppBar(
//       title: Text(widget.product.name),
//       backgroundColor: Color(0xFFFFCA28),
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(20),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
            
//             Container(
//               height: 240,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade300,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.asset(
//                   widget.product.image,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

            
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     widget.product.name,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey.shade800,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: toggleWishlist,
//                   icon: Icon(
//                     isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: isFavorite ? Colors.red : Colors.grey,
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             // Price
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '₹${widget.product.price}',
//                 style: TextStyle(
//                   fontSize: 22,
//                   color: Colors.teal.shade700,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Description
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 widget.product.description ?? 'No description available.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 textAlign: TextAlign.left,
//               ),
//             ),
//             const SizedBox(height: 30),
            
//             Row(
//               children: [
//                 // Add to Cart button
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () => toCart(context),
//                     icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
//                     label: Text(
//                       "Add to Cart",
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 3,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 16),

//                 // Quantity Selector
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove_circle_outline),
//                       onPressed: () {
//                         setState(() {
//                           if (cartItem.quantity > 1) {
//                             cartItem.quantity--;
//                           } else {
//                             cartItems.removeWhere((e) => e.name == widget.product.name);
//                           }
//                         });
//                       },
//                     ),
//                     Text('${cartItem.quantity}',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//                     IconButton(
//                       icon: Icon(Icons.add_circle_outline),
//                       onPressed: () {
//                         setState(() {
//                           cartItem.quantity++;
//                         });
//                       },
//                     ),
//                   ],
//                 )

//               ],
//             ),

//           ],
//         ),
//       ),
//     ),
//   );
// }
// }


// import 'package:flutter/material.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';
// import 'cart.dart';

// class ProductDetailPage extends StatelessWidget {
//   final CartItem product;

//   const ProductDetailPage({required this.product, super.key});

//   void toCart(BuildContext context) {
//     final existingItem = cartItems.firstWhere(
//       (item) => item.name == product.name,
//       orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
//     );

//     if (existingItem.name != '') {
//       existingItem.quantity++;
//     } else {
//       cartItems.add(
//         CartItem(
//           name: product.name,
//           price: product.price,
//           image: product.image,
//           quantity: 1,
//         ),
//       );
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Added to cart")),
//     );

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CartScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: Text(product.name),
//         backgroundColor: Color(0xFFFFCA28),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 240,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.shade300,
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.asset(
//                     product.image,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 product.name,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey.shade800,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 '₹${product.price}',
//                 style: TextStyle(
//                   fontSize: 22,
//                   color: Colors.teal.shade700,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 product.description ?? 'No description available.',
//                 style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: () => toCart(context),
//                   icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
//                   label: Text(
//                     "Add to Cart",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
