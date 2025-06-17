import 'package:flutter/material.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'shopit_scaffold.dart';
import 'product_detail.dart';
//import '../utility/seeding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/top_banner_categories.dart';


class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}
 
class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedCategoryIndex = 0;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> fetchCartFromFirestore() async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  final snapshot = await _firestore.collection('users').doc(userId).collection('cart').get();

  setState(() {
    cartItems = snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
  });
}
Future<void> addToCart(CartItem item) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  await _firestore.collection('users').doc(userId).collection('cart').doc(item.name).set(item.toMap());
}

Future<void> updateCartQuantity(CartItem item) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  await _firestore.collection('users').doc(userId).collection('cart').doc(item.name).update({'quantity': item.quantity});
}

Future<void> removeFromCart(String productName) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  await _firestore.collection('users').doc(userId).collection('cart').doc(productName).delete();
}

//   @override
// void initState() {
//   super.initState();
//   seedCategoriesToFirebase();
// }


  final List<Map<String, dynamic>> categoryList = [
    {'name': 'Grocery', 'icon': Icons.shopping_bag},
    {'name': 'Household', 'icon': Icons.cleaning_services},
    {'name': 'Beauty', 'icon': Icons.spa},
  ];

  Map<String, List<Map<String, dynamic>>> categoryProducts = {
    'Grocery': [],
    'Household': [],
    'Beauty': [],
  };

  bool isLoading = true;

  Future<void> fetchProductsFromFirestore() async {
    final firestore = FirebaseFirestore.instance;

    try {
      for (String category in categoryProducts.keys) {
        final snapshot = await firestore
            .collection('product')
            .where('section', isEqualTo: category.toLowerCase())
            .get();

        final products = snapshot.docs.map((doc) => doc.data()).toList();

        categoryProducts[category] = products;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFromFirestore().then((_) => fetchCartFromFirestore());
  } 
  List<Map<String, dynamic>> getSelectedProducts() {
  String selectedCategory = categoryList[selectedCategoryIndex]['name'];
  return categoryProducts[selectedCategory] ?? [];
}

  Widget buildSidebar() {
    return Container(
      width: 90,
      color: const Color.fromARGB(255, 236, 237, 237),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) {
                final category = categoryList[index];
                final isSelected = index == selectedCategoryIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    color: isSelected ? Colors.amber : Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Icon(category['icon'], color: isSelected ? const Color.fromARGB(255, 203, 17, 17) : Colors.grey, size: 28),
                        const SizedBox(height: 4),
                        Text(
                          category['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductGrid() {
    final products = getSelectedProducts();

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(    
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        final cartItem = cartItems.firstWhere(
          (item) => item.name == product['name'],
          orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
        );
        final inCart = cartItem.name != '';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(4.0), //8
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailPage(product: CartItem.fromMap(product)),
                          ),
                        );
                      },
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    product['image'],
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),      
                
                ),
                const SizedBox(height: 4), //4
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('₹${product['price']}'),
                const SizedBox(height: 2),
                inCart
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () async {
                              setState(() {
                                if (cartItem.quantity > 1) {
                                  cartItem.quantity--;
                                } else {
                                  cartItems.removeWhere((e) => e.name == cartItem.name);
                                }
                              });

                              if (cartItem.quantity > 0) {
                                await updateCartQuantity(cartItem);
                              } else {
                                await removeFromCart(cartItem.name);
                              }
                            },                           
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () async {
                              setState(() {
                                cartItem.quantity++;
                              });
                              await updateCartQuantity(cartItem);
                            },                      
                          ),
                        ],
                      )
                : Center(
                      child: 
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,                                  
                            elevation: 2,                      
                            shape: RoundedRectangleBorder(    
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            final existingItem = cartItems.firstWhere(
                              (item) => item.name == product['name'],
                              orElse: () => CartItem(name: '', price: 0, image: '', quantity: 0),
                            );

                            setState(() {
                              if (existingItem.name != '') {
                                existingItem.quantity++;
                              } else {
                                cartItems.add(CartItem.fromMap(product));
                              }
                            });

                            await addToCart(CartItem.fromMap(product));
                          },
                        child: Text("Add"),
                      ),
                )
              ],
            ),
          ),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShopitScaffold(
      currentIndex: 1,
      body: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildSidebar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    BannerCarousel(),
                    buildProductGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    ),
    );
  }
}



// import 'package:ecom_app/screens/shopit_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'product_detail.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';

// class CategoriesScreen extends StatefulWidget{
//   _CategoriesState createState() => _CategoriesState();
  
// }

// class _CategoriesState extends State<CategoriesScreen> {
//   final Map<String, int> cartQuantities = {};
  

//   final List<Map<String, dynamic>> grocery = [
//     {
//       'name': 'Atta',
//       'price': 300,
//       'image': 'assets/app_icon.png',
//       'description': '5 kg',
//     },
//     {
//       'name': 'Rice',
//       'price': 500,
//       'image': 'assets/app_icon.png',
//       'description': '5 kg',
//     },
//     {
//       'name': 'Dal',
//       'price': 200,
//       'image': 'assets/app_icon.png',
//       'description': '500 g',
//     },
//   ];

//   final List<Map<String, dynamic>> household = [
//     {
//       'name': 'Detergent',
//       'price': 60,
//       'image': 'assets/app_icon.png',
//       'description': '1 kg',
//     },
//     {
//       'name': 'Dishwasher',
//       'price': 65,
//       'image': 'assets/app_icon.png',
//       'description': '100 ml',
//     },
//     {
//       'name': 'Floor Cleaner',
//       'price': 100,
//       'image': 'assets/app_icon.png',
//       'description': '500 ml',
//     },
//   ];

//   final List<Map<String, dynamic>> beauty = [
//     {
//       'name': 'Shower Gel',
//       'price': 200,
//       'image': 'assets/app_icon.png',
//       'description': '200 ml',
//     },
//     {
//       'name': 'Body Lotion',
//       'price': 500,
//       'image': 'assets/app_icon.png',
//       'description': '500 ml',
//     },
//     {
//       'name': 'Shampoo',
//       'price': 100,
//       'image': 'assets/app_icon.png',
//       'description': '150 ml',
//     },
//   ];

//   Widget buildSection(String title, List<Map<String, dynamic>> products) {

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
            
//                 return Container(
//                   width: 160,
//                   margin: EdgeInsets.symmetric(horizontal: 4), //8
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
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
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: Text("₹${product['price']}"),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                           child: Text(product['description']),
//                         ),
//                         Padding(
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
//                       ],
//                     ),
//                   ),
//                 );
//             },


//           )         
//               ),
//       ]
            
//           );
//   }
        
      
    
  

//   @override
//   Widget build(BuildContext context) {
//     return ShopitScaffold(
//       currentIndex: 1,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             buildSection("Grocery & Kitchen", grocery),
//             buildSection("Household", household),
//             buildSection("Beauty & Self care", beauty),
//           ],
//         ),
//       ),
//     );
//   }
// }  

