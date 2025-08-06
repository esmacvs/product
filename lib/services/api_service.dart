import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prod_app/models/product.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ApiService {
  static const String baseUrl = "https://localhost:7240";
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

      if (jsonResponse != null &&
          jsonResponse is Map<String, dynamic> &&
          jsonResponse['token'] != null &&
          jsonResponse['token'] is String) {
        return jsonResponse['token'];
      } else {
        logger.w('Token alanı null ya da geçersiz.');
        return null;
      }
    } else {
      logger.w('Login failed with status: ${response.statusCode}');
      throw Exception('Login failed with status ${response.statusCode}');
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
static Future<List<Product>> fetchBooks() async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Token bulunamadı, lütfen giriş yapın');
  }

  final url = Uri.parse(
    '$baseUrl/api/Books?MinPrice=0&MaxPrice=10000&ValidPriceRange=true&PageNumber=1&PageSize=7&OrderBy=id',
  );

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> items = jsonResponse['books'] ?? [];

    return items.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('API’den kitaplar alınamadı: ${response.statusCode}');
  }
}



static Future<Map<String, dynamic>> fetchMe() async {
  final token = await getToken();
  if (token == null) throw Exception('Giriş yapılmamış');

  final url = Uri.parse('$baseUrl/api/Customers/me');  // Burayı Swagger'a göre ayarla

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    logger.i('fetchMe response body: ${response.body}');

    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    logger.w('Kullanıcı bilgileri alınamadı: ${response.statusCode}');
    throw Exception('Kullanıcı bilgileri alınamadı: ${response.statusCode}');
  }
}

static Future<dynamic> register(Map<String, dynamic> userData) async {
  final url = Uri.parse('$baseUrl/api/authentication');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    // Başarılı yanıt (200 veya 201)
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    // Hatalı yanıt (400+)
    final Map<String, dynamic> responseBody = jsonDecode(response.body);

    if (responseBody.containsKey('errors')) {
      // Backend validasyon hataları (alan bazlı)
      return {
        'errors': responseBody['errors']
      };
    } else if (responseBody.containsKey('message')) {
      // Genel hata mesajı
      return {
        'message': responseBody['message']
      };
    } else {
      return {
        'message': 'Bilinmeyen bir hata oluştu'
      };
    }
  } catch (e) {
    // JSON parse edilemedi veya bağlantı hatası oldu
    return {
      'message': 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.'
    };
  }
}



  // Token'ı sil
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }


static Future<void> borrowBook(int customerId, int bookId) async {
  final token = await getToken();
  if (token == null) throw Exception('Token bulunamadı.');

  final url = Uri.parse('$baseUrl/api/Loans/borrow?customerId=$customerId&bookId=$bookId');
  
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Kitap ödünç alınamadı: ${response.statusCode} - ${response.body}');
  }
}



}
