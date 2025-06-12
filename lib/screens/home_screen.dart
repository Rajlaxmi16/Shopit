import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_items.dart';
import '../data/cart_data.dart';
import 'product_detail.dart';
import 'shopit_scaffold.dart';
import '../widgets/top_banner_home.dart';
import '../widgets/intro_video.dart';
import 'package:collection/collection.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class ShopitHome extends StatefulWidget {
  @override
  _ShopitHomeState createState() => _ShopitHomeState();
}


class _ShopitHomeState extends State<ShopitHome> {

  bool isLoading = true;
  Map<String, List<CartItem>> allSections = {};
  

  Future<void> loadCartFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser; 
  if (user == null) return; 
  final uid = user.uid;

  final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        // .collection('carts')
        // .doc(user.uid)
        // .collection('items')
         .get();

  cartItems = snapshot.docs.map((doc) {
    final data = doc.data();
    return CartItem(
      name: data['name'],
      price: data['price'],
      image: data['image'],
      quantity: data['quantity'],
    );
  }).toList();

  setState(() {});
}
  Future<void> addToFirestoreCart(CartItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(item.name)
        .set({
      'name': item.name,
      'price': item.price,
      'image': item.image,
      'quantity': item.quantity,
    });
  }

  Future<void> updateCartQuantity(String name, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(name)
        .update({'quantity': quantity});
  }

  Future<void> removeFromFirestoreCart(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(name)
        .delete();
  }


  @override
  void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) => VideoPopup(),
    );
  });

  loadInitialData();
  
}
Future<void> loadInitialData() async {
  await loadCartFromFirestore();
  await loadAllSections();
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
      final cartItem = cartItems.firstWhere(
      (item) => item.name == data['name'],
      orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
    );
      return CartItem(
        name: data['name'],
        price: data['price'],
        image: data['image'],
        //quantity: data['quantity'] ?? 1,
        quantity: cartItem.name != '' ? cartItem.quantity : 1,
        description: data['description'],
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
                  CartItem? cartItem = cartItems.firstWhereOrNull(
                    (item) => item.name == product.name,
                  );

                  // final cartItem = cartItems.firstWhere(
                  //   (item) => item.name == product.name,
                  //   orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
                  // );

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
                                            if (cartItem != null && cartItem.quantity > 1) {
                                              cartItem.quantity--;
                                              updateCartQuantity(cartItem.name, cartItem.quantity);
                                            }
                                            // if (cartItem.quantity > 1) {
                                            //   cartItem.quantity--;
                                            //   updateCartQuantity(cartItem.name, cartItem.quantity);
                                            // } 
                                            else {
                                              cartItems.removeWhere((e) => e.name == product.name);
                                              removeFromFirestoreCart(product.name);
                                            }
                                          });
                                        },
                                      ),
                                      Text('${cartItem?.quantity ?? 1}'),
                                      //Text('${cartItem.quantity}'),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline),
                                        onPressed: () {
                                          setState(() {
                                            if (cartItem != null) {
                                              cartItem.quantity++;
                                              updateCartQuantity(cartItem.name, cartItem.quantity);
                                            }
                                            // cartItem.quantity++;
                                            // updateCartQuantity(cartItem.name, cartItem.quantity);
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
                                      onPressed: () async {
                                        setState(() {
                                          cartItems.add(CartItem(
                                            name: product.name,
                                            price: product.price,
                                            image: product.image,
                                            quantity: 1,
                                            description: product.description,
                                          ));
                                        });
                                        await addToFirestoreCart(product);  // ensure it gets saved
                                        setState(() {});  // force UI refresh
                                      },

                                      // onPressed: () {
                                      //   setState(() {
                                      //     cartItems.add(product);
                                      //     addToFirestoreCart(product);
                                      //   });
                                      // },
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


