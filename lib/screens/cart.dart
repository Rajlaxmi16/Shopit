import 'package:ecom_app/screens/order_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/cart_data.dart';
import '../models/cart_items.dart';
import 'home_screen.dart';
import 'shopit_scaffold.dart';
import '../services/payment_service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  bool _isCouponApplied = false;
  double _discountAmount = 0.0;

  void toHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ShopitHome()),
    );
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
                                onPressed: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      cartItems.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                              ),
                            ],
                          ),
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



// import 'package:ecom_app/screens/order_confirmed.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../data/cart_data.dart';
// import '../models/cart_items.dart';
// import 'home_screen.dart';
// import 'shopit_scaffold.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as flutter_stripe;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../services/payment_service.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   final _couponController = TextEditingController();
//   bool _isCouponApplied = false;
//   double _discountAmount = 0.0;

//   void toHome(BuildContext context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => ShopitHome()),
//     );
//   }

//   void pay(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("User not logged in.")),
//       );
//       return;
//     }

//     try{
//       int total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
//     double gst = total * 0.05;
//     //double paytotal = total + gst;
//     double paytotal = total + gst - _discountAmount;
//     //double amountInPaise = (paytotal * 100).round();

//      //PaymentService paymentService = PaymentService();
//     //await paymentService.makePayment(amountInPaise);

//     final url = Uri.parse('https://evqsvbdfvi.execute-api.us-east-1.amazonaws.com/dev/createPaymentIntent');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'amount': (paytotal * 100).round()}), 
//     );

//     final jsonResponse = json.decode(response.body);
//     final clientSecret = jsonResponse['clientSecret'];

//     await flutter_stripe.Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: flutter_stripe.SetupPaymentSheetParameters(
//         paymentIntentClientSecret: clientSecret,
//         merchantDisplayName: 'Shopit',
//       ),
//     );

//     await flutter_stripe.Stripe.instance.presentPaymentSheet();

//     final order = {
//       'uid': user.uid,
//       'items': cartItems.map((item) => {
//         'name': item.name,
//         'price': item.price,
//         'quantity': item.quantity,
//         'image': item.image,
//       }).toList(),
//       'total': total,
//       'gst': gst,
//       'discount': _discountAmount,
//       'payTotal': paytotal - _discountAmount,
//       'couponApplied': _isCouponApplied,
//       'timestamp': Timestamp.now(),
//     };

//     await FirebaseFirestore.instance.collection('orders').add(order);

//     setState(() {
//       cartItems.clear();
//       _isCouponApplied = false;
//       _couponController.clear();
//       _discountAmount = 0.0;
//     });

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => OrderConfiremed()),
//     );

//     }catch (e) {
//     print('Payment error: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment failed: $e")),
//     );
//   }
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     int total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
//     double gst = total * 0.05;
//     double paytotal = total + gst;

//     if (_isCouponApplied) {
//       _discountAmount = total * 0.25;
//     }

//     return ShopitScaffold(
//       currentIndex: 2,
//       body: cartItems.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/empty_cart.png', width: 200, height: 250),
//                   SizedBox(height: 5),
//                   Text(
//                     'Oops! Your cart is empty.',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 107, 104, 104),
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   ElevatedButton(
//                     onPressed: () => toHome(context),
//                     child: Text('Shop Now'),
//                   )
//                 ],
//               ),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       final item = cartItems[index];
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           leading: Image.asset(item.image, width: 50),
//                           title: Text(item.name),
//                           subtitle: Text("₹${item.price} x ${item.quantity}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.remove_circle_outline),
//                                 onPressed: () {
//                                   setState(() {
//                                     if (item.quantity > 1) {
//                                       item.quantity--;
//                                     } else {
//                                       cartItems.removeAt(index);
//                                     }
//                                   });
//                                 },
//                               ),
//                               Text('${item.quantity}'),
//                               IconButton(
//                                 icon: Icon(Icons.add_circle_outline),
//                                 onPressed: () {
//                                   setState(() {
//                                     item.quantity++;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _couponController,
//                           decoration: InputDecoration(
//                             hintText: 'Enter coupon code',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             if (_couponController.text.trim().toLowerCase() == 'save25' &&
//                                 !_isCouponApplied) {
//                               _isCouponApplied = true;
//                               _discountAmount = total * 0.25;
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Coupon Applied! 25% discount")),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Invalid or already applied coupon.")),
//                               );
//                             }
//                           });
//                         },
//                         child: Text(_isCouponApplied ? "Applied" : "Apply"),
//                         style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(    
//                             borderRadius: BorderRadius.circular(10),
//                       ),
//                       ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Card(
//                   color: Color.fromARGB(255, 207, 235, 233),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Container(
//                       width: double.infinity,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Total: ₹$total', style: TextStyle(fontSize: 16)),
//                           if (_isCouponApplied)
//                             Text('Coupon Discount: -₹${_discountAmount.toStringAsFixed(2)}',
//                                 style: TextStyle(fontSize: 14, color: Colors.green)),
//                           Text('GST: ₹${gst.toStringAsFixed(2)}'),
//                           Text('Delivery charges: FREE'),
//                           Text(
//                             'Payable: ₹${(paytotal - _discountAmount).toStringAsFixed(2)}',
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () => PaymentService().makePayment(paytotal - _discountAmount, context),//pay(context),
//                             child: Text("Pay Now"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               foregroundColor: Colors.white,
//                               elevation: 4,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }



// import 'package:ecom_app/screens/shopit_scaffold.dart';
// import 'package:flutter/material.dart';
// import '../data/cart_data.dart';
// import 'home_screen.dart';

// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   void removeItem(int index) {
//     setState(() {
//       if (index >= 0 && index < cartItems.length) {
//         setState(() {
//         cartItems.removeAt(index);
//       });
//       }
//     });
//   }
//   void toHome(BuildContext context){
//     Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => ShopitHome()),
//           );
//   }
//   @override
//   Widget build(BuildContext context) {
//     int total = cartItems.fold(0, (sum, item) => sum + item.price);

//     return ShopitScaffold(
//       currentIndex: 2,
//       body: cartItems.isEmpty
//           ? Center(child:Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//               'assets/empty_cart.png', 
//               width: 200,
//               height: 250,
//               ),
//               SizedBox(height: 5),
//               Text(
//                 'Oops! Your cart is empty.',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 107, 104, 104),
//                 ),
//               ),
//               SizedBox(height: 5),
//               ElevatedButton(
//                 onPressed: () => toHome(context),
//                  child: Text(
//                   'Shop Now',                  
//                  ))
//             ],
//           ),)
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       if (index < 0 || index >= cartItems.length) {
//                         return SizedBox(); 
//                       }
//                       final item = cartItems[index];
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           leading: Image.asset(item.image, width: 50, height: 50),
//                           title: Text(item.name),
//                           subtitle: Text("₹${item.price}"),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => removeItem(index),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text('Total: ₹$total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//     );
//   }
// }
