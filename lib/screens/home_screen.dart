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
      'name': 'Red label tea',
      'price': 55,
      'image': 'assets/app_icon.png',
      'description': '100 g',
    },
    {
      'name': 'Amul Milk',
      'price': 26,
      'image': 'assets/app_icon.png',
      'description': '500 ml',
    },
    {
      'name': 'Madhur Sugar',
      'price': 56,
      'image': 'assets/app_icon.png',
      'description': '1 kg',
    },
  ];

  final List<Map<String, dynamic>> trending = [
    {
      'name': 'Maggei masala',
      'price': 60,
      'image': 'assets/app_icon.png',
      'description': '2 Minutes instant noodles',
    },
    {
      'name': 'Knor soup',
      'price': 65,
      'image': 'assets/app_icon.png',
      'description': 'No added preservatives',
    },
    {
      'name': 'Chefs Basket Pasta',
      'price': 50,
      'image': 'assets/app_icon.png',
      'description': 'Drum wheat penne domestic pasta',
    },
  ];

  final List<Map<String, dynamic>> topDeals = [
    {
      'name': 'Tender Coconut',
      'price': 65,
      'image': 'assets/app_icon.png',
      'description': 'Free coriander offer',
    },
    {
      'name': 'Watermelon',
      'price': 63,
      'image': 'assets/app_icon.png',
      'description': 'Free banana offer',
    },
    {
      'name': 'Chikoo',
      'price': 48,
      'image': 'assets/app_icon.png',
      'description': 'Free chillies offer',
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
                  margin: EdgeInsets.symmetric(horizontal: 4),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(product['description']),
                        )
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

