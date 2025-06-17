import 'package:ecom_app/screens/order_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'home_screen.dart';
import 'shopit_scaffold.dart';
import '../services/payment_service.dart';
import 'product_detail.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  bool _isCouponApplied = false;
  double _discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartFromFirestore();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCartFromFirestore();
  }

  Future<void> fetchCartFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
         .get();

    setState(() {
      cartItems.clear();
      cartItems.addAll(snapshot.docs.map((doc) {
        final data = doc.data();
        return CartItem(
          name: data['name'],
          price: data['price'],
          image: data['image'],
          quantity: data['quantity'],
          description: data['description'],
        );
      }));
    });
  }
  void updateQuantityInFirestore(CartItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(item.name);

    if (item.quantity > 0) {
      await docRef.set({
        'name': item.name,
        'price': item.price,
        'image': item.image,
        'quantity': item.quantity,
      });
    } else {
      
      await docRef.delete();
    }
  }


  void toHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ShopitHome()),
    );
    fetchCartFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    int total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
    double gst = total * 0.05;
    double paytotal = total + gst;

    if (_isCouponApplied) {
      _discountAmount = total * 0.25;
    }

    return ShopitScaffold(
      currentIndex: 2,
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/empty_cart.png', width: 200, height: 250),
                  SizedBox(height: 5),
                  Text(
                    'Oops! Your cart is empty.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 107, 104, 104),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => toHome(context),
                    child: Text('Shop Now'),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Image.asset(item.image, width: 50),
                          title: Text(item.name),
                          subtitle: Text("₹${item.price} x ${item.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () async {
                                if (item.quantity > 1) {
                                  setState(() {
                                    item.quantity--;
                                  });
                                  updateQuantityInFirestore(item);
                                } else {
                                  
                                  final user = FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('cart')
                                        .doc(item.name)
                                        .delete();
                                  }

                                  setState(() {
                                    cartItems.removeAt(index);
                                  });
                                }
                              },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                  updateQuantityInFirestore(item);
                                },
                              ),
                            ],
                          ),

                          
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(product: item),
                              ),
                            );
                          },
                        ),
                      );
 
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: 'Enter coupon code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            if (_couponController.text.trim().toLowerCase() == 'save25' &&
                                !_isCouponApplied) {
                              _isCouponApplied = true;
                              _discountAmount = total * 0.25;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Coupon Applied! 25% discount")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid or already applied coupon.")),
                              );
                            }
                          });
                        },
                        child: Text(_isCouponApplied ? "Applied" : "Apply"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: Color.fromARGB(255, 207, 235, 233),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Total: ₹$total', style: TextStyle(fontSize: 16)),
                          if (_isCouponApplied)
                            Text('Coupon Discount: -₹${_discountAmount.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, color: Colors.green)),
                          Text('GST: ₹${gst.toStringAsFixed(2)}'),
                          Text('Delivery charges: FREE'),
                          Text(
                            'Payable: ₹${(paytotal - _discountAmount).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              PaymentService().makePayment(
                                context,
                                isCouponApplied: _isCouponApplied,
                                discountAmount: _discountAmount,
                              );
                            },
                            child: Text("Pay Now"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}



