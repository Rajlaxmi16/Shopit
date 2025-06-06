import 'package:cloud_firestore/cloud_firestore.dart';

void seedCategoriesToFirebase() async {
  final firestore = FirebaseFirestore.instance;

  final categories = {
    'grocery': [
      {
        'name': 'Atta',
        'price': 300,
        'image': 'assets/atta.png',
        'description': '5 kg',
      },
      {
        'name': 'Rice',
        'price': 500,
        'image': 'assets/rice.png',
        'description': '5 kg',
      },
      {
        'name': 'Dal',
        'price': 200,
        'image': 'assets/dal.png',
        'description': '500 g',
      },
      {
        'name': 'Peanuts',
        'price': 200,
        'image': 'assets/peanuts.png',
        'description': '500 g',
      },
    ],
    'household': [
      {
        'name': 'Detergent',
        'price': 60,
        'image': 'assets/detergent.png',
        'description': '1 kg',
      },
      {
        'name': 'Dishwasher',
        'price': 65,
        'image': 'assets/dishwasher.png',
        'description': '100 ml',
      },
      {
        'name': 'Floor Cleaner',
        'price': 100,
        'image': 'assets/floor.png',
        'description': '500 ml',
      },
    ],
    'beauty': [
      {
        'name': 'Shower Gel',
        'price': 200,
        'image': 'assets/gel.png',
        'description': '200 ml',
      },
      {
        'name': 'Body Lotion',
        'price': 500,
        'image': 'assets/lotion.png',
        'description': '500 ml',
      },
      {
        'name': 'Shampoo',
        'price': 100,
        'image': 'assets/shampoo.png',
        'description': '150 ml',
      },
    ],
  };

  for (var category in categories.entries) {
    final catDoc = firestore.collection('products').doc(category.key);
    final itemsCollection = catDoc.collection('items');

    for (var item in category.value) {
      await itemsCollection.add(item);
    }
  }

  print("Seeding complete.");
}
