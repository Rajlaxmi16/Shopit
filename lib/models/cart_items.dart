class CartItem {
  final String name;
  final String image;
  final int price;
  int quantity;

  CartItem({
    required this.name,
    required this.image, 
    required this.price,
    this.quantity=1
    });
    Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'],
      image: map['image'],
      price: map['price'],
      quantity: map['quantity'] ?? 1,
    );
  }
}




