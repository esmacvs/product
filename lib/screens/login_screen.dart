import 'package:flutter/material.dart';
import 'package:prod_app/screens/home_screen.dart';
import 'package:prod_app/screens/register_screen.dart';
import 'package:prod_app/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = await ApiService.login(
      _userNameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (token != null) {
      await ApiService.saveToken(token);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.";
      });
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E6), // Bej arka plan
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000), // Bordo
        title: const Text(
          'Kütüphane Girişi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFCDD2), // Açık bordo/pembe ton
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.local_library, size: 100, color: Color(0xFF800000)),
              const SizedBox(height: 16),
              const Text(
                'Hoş Geldiniz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF800000),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000), // Bordo
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Yazı rengi beyaz
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _goToRegister,
                child: const Text(
                  'Hesabınız yok mu? Kayıt olun',
                  style: TextStyle(
                    color: Color(0xFF800000),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
