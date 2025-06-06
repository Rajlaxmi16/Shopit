import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_items.dart';
import '../data/cart_data.dart';
import 'product_detail.dart';
import 'shopit_scaffold.dart';
import '../widgets/top_banner_home.dart';

class ShopitHome extends StatefulWidget {
  @override
  _ShopitHomeState createState() => _ShopitHomeState();
}


class _ShopitHomeState extends State<ShopitHome> {

  bool isLoading = true;
  Map<String, List<CartItem>> allSections = {};

  @override
void initState() {
  super.initState();
  loadAllSections();
}

Future<void> loadAllSections() async {
  final recommended = await fetchProducts("recommended");
  final trending = await fetchProducts("trending");
  final topDeals = await fetchProducts("topDeals");

  setState(() {
    allSections = {
      "recommended": recommended,
      "trending": trending,
      "topDeals": topDeals,
    };
    isLoading = false;
  });
}

  
  Future<List<CartItem>> fetchProducts(String section) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('product')
        .where('section', isEqualTo: section)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CartItem(
        name: data['name'],
        price: data['price'],
        image: data['image'],
        quantity: data['quantity'] ?? 1,
      );
    }).toList();
  }

  Widget buildSection(String title, String sectionKey) {
    return FutureBuilder<List<CartItem>>(
      future: fetchProducts(sectionKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        final products = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final inCart = cartItems.any((item) => item.name == product.name);
                  final cartItem = cartItems.firstWhere(
                    (item) => item.name == product.name,
                    orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
                  );

                  return Container(
                    width: 160,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('Product tapped: $product');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(product: product), //:product
                                ),
                              );
                            },
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              product.image,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text("₹${product.price}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: inCart
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            if (cartItem.quantity > 1) {
                                              cartItem.quantity--;
                                            } else {
                                              cartItems.removeWhere((e) => e.name == product.name);
                                            }
                                          });
                                        },
                                      ),
                                      Text('${cartItem.quantity}'),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            cartItem.quantity++;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,                                  
                                        elevation: 2,                      
                                        shape: RoundedRectangleBorder(    
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          cartItems.add(product);
                                        });
                                      },
                                      child: Text("Add"),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShopitScaffold(
      currentIndex: 0,
    
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            BannerCarousel(),
            SizedBox(height: 16),
            buildSection("Recommended for You", "recommended"),
            buildSection("Trending", "trending"),
            buildSection("Top Deals", "topDeals"),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';
// import 'product_detail.dart';
// import 'shopit_scaffold.dart';
// import '../widgets/top_banner_home.dart';

// class ShopitHome extends StatefulWidget {
//   @override
//   _ShopitHomeState createState() => _ShopitHomeState();
// }


// class _ShopitHomeState extends State<ShopitHome> {

//   Future<List<CartItem>> fetchProducts(String section) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('product')
//         .where('section', isEqualTo: section)
//         .get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return CartItem(
//         name: data['name'],
//         price: data['price'],
//         image: data['image'],
//         quantity: data['quantity'] ?? 1,
//       );
//     }).toList();
//   }

//   final Map<String, int> cartQuantities = {};

//   // final List<Map<String, dynamic>> recommended = [
//   //   {
//   //     'name': 'Red label tea',
//   //     'price': 55,
//   //     'image': 'assets/app_icon.png',
//   //     'description': '100 g',
//   //   },
//   //   {
//   //     'name': 'Amul Milk',
//   //     'price': 26,
//   //     'image': 'assets/app_icon.png',
//   //     'description': '500 ml',
//   //   },
//   //   {
//   //     'name': 'Madhur Sugar',
//   //     'price': 56,
//   //     'image': 'assets/app_icon.png',
//   //     'description': '1 kg',
//   //   },
//   // ];
//   //   final List<Map<String, dynamic>> trending = [
//   //   {
//   //     'name': 'Maggei masala',
//   //     'price': 60,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'Instant noodles',
//   //   },
//   //   {
//   //     'name': 'Knor soup',
//   //     'price': 65,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'No preservatives',
//   //   },
//   //   {
//   //     'name': 'Chefs Basket Pasta',
//   //     'price': 50,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'Wheat pasta',
//   //   },
//   // ];

//   // final List<Map<String, dynamic>> topDeals = [
//   //   {
//   //     'name': 'Tender Coconut',
//   //     'price':  65,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'Free coriander offer',
//   //   },
//   //   {
//   //     'name': 'Watermelon',
//   //     'price': 63,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'Free banana offer',
//   //   },
//   //   {
//   //     'name': 'Chikoo',
//   //     'price': 48,
//   //     'image': 'assets/app_icon.png',
//   //     'description': 'Free chillies offer',
//   //   },
//   // ];
//   Widget buildSection(String title,String sectionKey) { //List<Map<String, dynamic>> products) {
//     return FutureBuilder<List<CartItem>>(
//       future: fetchProducts(sectionKey),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return SizedBox.shrink();
//         }

//         final products = snapshot.data!;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(
//           height: 240,
//           child: 
//           ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               final cartItem = cartItems.firstWhere(
//                 (item) => item.name == product['name'],
//                 orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
//               );
//               final inCart = cartItem.name != '';

//             return Container(
//               width: 160,
//               margin: EdgeInsets.symmetric(horizontal: 4),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ProductDetailPage(product: product),
//                           ),
//                         );
//                       },
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                   child: Image.asset(
//                     product['image'],
//                     height: 100,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Text("₹${product['price']}"),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Text("${product['description']}"),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: inCart
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.remove_circle_outline),
//                             onPressed: () {
//                               setState(() {
//                                 if (cartItem.quantity > 1) {
//                                   cartItem.quantity--;
//                                 } else {
//                                   cartItems.removeWhere((e) => e.name == product['name']);
//                                 }
//                               });
//                             },
//                           ),
//                           Text('${cartItem.quantity}'),
//                           IconButton(
//                             icon: Icon(Icons.add_circle_outline),
//                             onPressed: () {
//                               setState(() {
//                                 cartItem.quantity++;
//                               });
//                             },
//                           ),
//                         ],
//                       )
//                     : 
//                     Center(
//                       child: 
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,                                  
//                             elevation: 2,                      
//                             shape: RoundedRectangleBorder(    
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         onPressed: () {
//                           setState(() {
//                             cartItems.add(CartItem(
//                               name: product['name'],
//                               price: product['price'],
//                               image: product['image'],
//                               quantity: 1,
//                             ));
//                           });
//                         },
//                         child: Text("Add"),
//                       ),

//                     ),
                    
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//     ),

//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ShopitScaffold(
//       currentIndex: 0,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 16),
//             BannerCarousel(),
//             SizedBox(height: 16),
//             buildSection("Recommended for You", recommended),
//             buildSection("Trending", trending),
//             buildSection("Top Deals", topDeals),
//           ],
//         ),
//       ),
//     );
//   }
// }