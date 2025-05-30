import 'package:ecom_app/screens/shopit_scaffold.dart';
import 'package:flutter/material.dart';
import 'product_detail.dart';

class CategoriesScreen extends StatefulWidget{
  _CategoriesState createState() => _CategoriesState();
  
}

class _CategoriesState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> grocery = [
    {
      'name': 'Atta',
      'price': 300,
      'image': 'assets/app_icon.png',
      'description': '5 kg',
    },
    {
      'name': 'Rice',
      'price': 500,
      'image': 'assets/app_icon.png',
      'description': '5 kg',
    },
    {
      'name': 'Dal',
      'price': 200,
      'image': 'assets/app_icon.png',
      'description': '500 g',
    },
  ];

  final List<Map<String, dynamic>> household = [
    {
      'name': 'Detergent',
      'price': 60,
      'image': 'assets/app_icon.png',
      'description': '1 kg',
    },
    {
      'name': 'Dishwasher',
      'price': 65,
      'image': 'assets/app_icon.png',
      'description': '100 ml',
    },
    {
      'name': 'Floor Cleaner',
      'price': 100,
      'image': 'assets/app_icon.png',
      'description': '500 ml',
    },
  ];

  final List<Map<String, dynamic>> beauty = [
    {
      'name': 'Shower Gel',
      'price': 200,
      'image': 'assets/app_icon.png',
      'description': '200 ml',
    },
    {
      'name': 'Body Lotion',
      'price': 500,
      'image': 'assets/app_icon.png',
      'description': '500 ml',
    },
    {
      'name': 'Shampoo',
      'price': 100,
      'image': 'assets/app_icon.png',
      'description': '150 ml',
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
                  margin: EdgeInsets.symmetric(horizontal: 4), //8
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
      currentIndex: 1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSection("Grocery & Kitchen", grocery),
            buildSection("Household", household),
            buildSection("Beauty & Self care", beauty),
          ],
        ),
      ),
    );
  }
}
