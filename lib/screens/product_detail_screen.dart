import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fiyat: ${product['price']} ₺', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text('Açıklama: ${product['description'] ?? "Yok"}'),
          ],
        ),
      ),
    );
  }
}
