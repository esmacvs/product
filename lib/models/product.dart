class Product {
  final int id;
  final String title;
  final String author;
  final String description;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'stock': stock,
    };
  }
}
