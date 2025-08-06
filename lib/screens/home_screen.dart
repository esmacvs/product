import 'package:flutter/material.dart';
import 'package:prod_app/services/api_service.dart';
import 'package:prod_app/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? user;
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final userData = await ApiService.fetchMe();
      final productData = await ApiService.fetchBooks();
      setState(() {
        user = userData;
        products = productData;
        isLoading = false;
      });
    } catch (e) {
      print("Hata oluştu: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ApiService.clearToken();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("Kullanıcı verisi alınamadı"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hoş geldin, ${user!['firstName']} ${user!['lastName']}"),
                      const SizedBox(height: 16),
                      const Text("Ürünler:", style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                           return ListTile(
  leading: const Icon(Icons.book, size: 40),
  title: Text(product.title),
  subtitle: Text(product.author),
  trailing: Text('Stok: ${product.stock}'),
  onTap: () {
    Navigator.pushNamed(
      context,
      '/product',
      arguments: product,
    );
  },
);

                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
