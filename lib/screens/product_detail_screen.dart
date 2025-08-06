import 'package:flutter/material.dart';
import 'package:prod_app/models/product.dart';
import 'package:prod_app/services/api_service.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.book, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text("Kitap Adı: ${product.title}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text("Yazar: ${product.author}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Stok: ${product.stock}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Açıklama:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(product.description ?? "Açıklama yok"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: product.stock > 0
                    ? () async {
                        try {
                          final me = await ApiService.fetchMe(); // Kullanıcı bilgisi al
                          final customerId = me['id']; // ID'yi al
                          
                          await ApiService.borrowBook(customerId, product.id);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kitap başarıyla ödünç alındı!')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: $e')),
                            );
                          }
                        }
                      }
                    : null,
                child: const Text("Ödünç Al"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
