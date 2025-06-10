import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_items.dart';
import '../data/cart_data.dart';
import 'product_detail.dart';
import 'shopit_scaffold.dart';
import '../widgets/top_banner_home.dart';
import '../widgets/intro_video.dart';
//import 'package:shared_preferences/shared_preferences.dart';


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

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) => VideoPopup(),
    );
  });

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


