import 'package:flutter/material.dart';
import 'package:prod_app/screens/home_screen.dart';
import 'package:prod_app/screens/login_screen.dart';
import 'package:prod_app/screens/register_screen.dart';
import 'package:prod_app/screens/product_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ürün Uygulaması',
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/product': (context) => const ProductDetailScreen(),
      },
    );
  }
}
