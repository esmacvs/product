import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prod_app/models/product.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ApiService {
  static const String baseUrl = 'https://localhost:7240';
 // Android emulator için localhost

  // Login: token döndürür, başarısızsa null
 static Future<String?> login(String userName, String password) async {
  try {
    final url = Uri.parse('$baseUrl/api/authentication/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userName': userName,
        'password': password,
      }),
    );

    logger.i('Login response status: ${response.statusCode}');
    logger.i('Login response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['token'] as String?;
    } else {
  logger.w('Login failed with status: ${response.statusCode}');
  throw Exception('Login failed');
}

  } catch (e) {
    logger.e('Login error: $e');
    return null;
  }
}

  // Token'ı kaydet
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Token'ı al
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Ürünleri çek (token gerekli)
  static Future<List<Product>> fetchProducts() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token bulunamadı, lütfen giriş yapın');
    }

    final url = Uri.parse(
      '$baseUrl/api/products?MinPrice=0&MaxPrice=10000&ValidPriceRange=true&PageNumber=1&PageSize=7&OrderBy=id',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('API’den ürünler alınamadı: ${response.statusCode}');
    }
  }
}
