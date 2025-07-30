class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

Map<String, dynamic> productToJson(Product product) {
  return {
    'id': product.id,
    'name': product.name,
    'price': product.price,
  };
}