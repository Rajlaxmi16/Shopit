import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shopit_scaffold.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'product_detail.dart';
import '../models/cart_items.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _addressController = TextEditingController();
  bool isEditing = false;
  String? savedAddress;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  void loadAddress() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['address'] != null) {
        final address = doc['address'];
        setState(() {
          savedAddress = address;
          _addressController.text = address;
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> saveAddress() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final address = _addressController.text.trim();

      if (address.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'address': address,
          'email': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        setState(() {
          savedAddress = address;
          isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address saved successfully')),
        );

        setState(() => isLoading = false);
      }
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ShopitScaffold(
      currentIndex: 3,
      body : Stack(
        children: [
          SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                if (user != null)
                  Expanded(
                    child: Text(
                      user.email ?? 'No email found',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24),

            
            Text("Shipping Address", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),

            if (savedAddress != null && !isEditing)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.home, color: Colors.teal),
                      SizedBox(width: 12),
                      Expanded(child: Text(savedAddress!)),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey[700]),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter your full address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                            _addressController.text = savedAddress ?? '';
                          });
                        },
                        child: Text("Cancel"),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          saveAddress();
                        },
                        child: Text("Save Address"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 24),

            
            Text("Order History", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('uid', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("No orders found.");
                }

                final orders = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: orders.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final data = orders[index].data() as Map<String, dynamic>;
                    final total = data['payTotal'];
                    final status = "Confirmed"; 
                    final date = DateFormat('dd MMM yyyy – hh:mm a')
                        .format((data['timestamp'] as Timestamp).toDate());

                    return ListTile(
                      leading: Icon(Icons.receipt_long),
                      title: Text("₹$total - $status"),
                      subtitle: Text(date),
                    );
                  },
                );
              },
            ),

            SizedBox(height: 32),
            Text("My Wishlist", style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user?.uid)
                    .collection('wishlist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No wishlist items yet.");
                  }

                  final wishlistItems = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: wishlistItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final doc = wishlistItems[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                  product: CartItem(
                                    name: data['name'],
                                    price: data['price'],
                                    image: data['image'],
                                    quantity: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                          leading: Image.asset(data['image'], width: 50),
                          title: Text(data['name']),
                          subtitle: Text('₹${data['price']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .collection('wishlist')
                                  .doc(doc.id)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Removed from wishlist')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),


            
            Center(
              child: ElevatedButton.icon(
                onPressed: () => logout(context),
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      if (isLoading)
      Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(child: CircularProgressIndicator()),
      ),
        ],
      ),
    );
  }
}


