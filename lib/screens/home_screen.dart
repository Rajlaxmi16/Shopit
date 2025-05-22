import 'package:ecom_app/screens/shopit_scaffold.dart';
import 'package:flutter/material.dart';
import 'product_detail.dart'; 

class ShopitHome extends StatefulWidget {
  @override
  _ShopitHomeState createState() => _ShopitHomeState();
}

class _ShopitHomeState extends State<ShopitHome> {
  final List<Map<String, dynamic>> recommended = [
    {
      'name': 'Wireless Headphones',
      'price': 1999,
      'image': 'assets/app_icon.png',
      'description': 'High-quality wireless headphones with noise cancellation.',
    },
    {
      'name': 'Smart Watch',
      'price': 2999,
      'image': 'assets/app_icon.png',
      'description': 'Track your fitness with this stylish smart watch.',
    },
    {
      'name': 'Smart Watch 2',
      'price': 2999,
      'image': 'assets/app_icon.png',
      'description': 'Track your fitness with this stylish smart watch.',
    },
  ];

  final List<Map<String, dynamic>> trending = [
    {
      'name': 'Running Shoes',
      'price': 1499,
      'image': 'assets/app_icon.png',
      'description': 'Comfortable shoes perfect for daily running.',
    },
    {
      'name': 'Bluetooth Speaker',
      'price': 1299,
      'image': 'assets/app_icon.png',
      'description': 'Compact speaker with powerful sound.',
    },
    {
      'name': 'Bluetooth Speaker 2',
      'price': 1299,
      'image': 'assets/app_icon.png',
      'description': 'Compact speaker with powerful sound.',
    },
  ];

  final List<Map<String, dynamic>> topDeals = [
    {
      'name': 'Laptop Bag',
      'price': 999,
      'image': 'assets/app_icon.png',
      'description': 'Durable and stylish bag for laptops.',
    },
    {
      'name': 'Gaming Mouse',
      'price': 799,
      'image': 'assets/app_icon.png',
      'description': 'Precision mouse for gaming enthusiasts.',
    },
    {
      'name': 'Gaming Mouse 2 ',
      'price': 799,
      'image': 'assets/app_icon.png',
      'description': 'Precision mouse for gaming enthusiasts.',
    },
  ];

  Widget buildSection(String title, List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            product['image'],
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("₹${product['price']}"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShopitScaffold(
      currentIndex: 0,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSection("Recommended for You", recommended),
            buildSection("Trending Now", trending),
            buildSection("Top Deals", topDeals),
          ],
        ),
      ),
    );
  }
}

