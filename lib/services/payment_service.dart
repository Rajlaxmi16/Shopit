import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/cart_data.dart';
import '../screens/order_confirmed.dart';

class PaymentService {
  Future<void> makePayment(BuildContext context, {
    required bool isCouponApplied,
    required double discountAmount,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in.")),
      );
      return;
    }

    try {
      int total = cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);
      double gst = total * 0.05;
      double paytotal = total + gst - discountAmount;

      final url = Uri.parse(
          'https://evqsvbdfvi.execute-api.us-east-1.amazonaws.com/dev/createPaymentIntent');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': (paytotal * 100).round()}),
      );

      final jsonResponse = json.decode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Shopit',
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      final order = {
        'uid': user.uid,
        'items': cartItems.map((item) => {
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
              'image': item.image,
            }).toList(),
        'total': total,
        'gst': gst,
        'discount': discountAmount,
        'payTotal': paytotal,
        'couponApplied': isCouponApplied,
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('orders').add(order);

      cartItems.clear();
      // Clear Firestore cart
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final snapshot = await cartRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OrderConfiremed()),
      );
    } catch (e) {
      print('Payment error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PaymentService {
//   Future<void> makePayment(double amountInPaise, BuildContext context) async {
//   try {
//     // Show loading
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Center(child: CircularProgressIndicator()),
//     );

//     // Step 1: Create PaymentIntent
//     final response = await http.post(
//       Uri.parse('https://evqsvbdfvi.execute-api.us-east-1.amazonaws.com/dev/createPaymentIntent'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'amount': amountInPaise}),
//     );

//     if (response.statusCode != 200) {
//       Navigator.of(context).pop(); // remove loader
//       throw Exception('Failed to create PaymentIntent');
//     }

//     final jsonResponse = jsonDecode(response.body);
//     final clientSecret = jsonResponse['clientSecret'];

//     // Step 2: Init Payment Sheet
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: clientSecret,
//         merchantDisplayName: 'Shopit',
//       ),
//     );

//     Navigator.of(context).pop(); // remove loader

//     // Step 3: Present Payment Sheet
//     await Stripe.instance.presentPaymentSheet();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment successful!")),
//     );
//   } catch (e) {
//     Navigator.of(context).pop(); // ensure loader is removed
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment failed: $e")),
//     );
//     print('Payment error: $e');
//   }
// }

  // Future<void> makePayment(int amountInPaise) async {
  //   try {
  //     // Step 1: Call your Lambda URL
  //     final response = await http.post(
  //       Uri.parse('https://evqsvbdfvi.execute-api.us-east-1.amazonaws.com/dev/createPaymentIntent'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'amount': amountInPaise}),
  //     );

  //     final jsonResponse = jsonDecode(response.body);

  //     // Step 2: Initialize Stripe
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: jsonResponse['clientSecret'],
  //         merchantDisplayName: 'Shopit',
  //         //style: ThemeMode.light,
  //       ),
  //     );

  //     // Step 3: Show Payment Sheet
  //     await Stripe.instance.presentPaymentSheet();

  //     print('Payment completed');
  //   } catch (e) {
  //     print('Payment failed: $e');
  //   }
  // }
//}
