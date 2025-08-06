import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prod_app/services/api_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  Map<String, List<String>> _fieldErrors = {};

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
        _fieldErrors = {};
      });

      final result = await ApiService.register({
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "userName": _userNameController.text.trim(),
        "email": _emailController.text.trim(),
        "phoneNumber": _phoneNumberController.text.trim(),
        "password": _passwordController.text.trim(),
        "roles": ["user"],
      });

      debugPrint("API result: $result");

      setState(() {
        _isLoading = false;
      });

      if (result is bool && result == true) {
        setState(() {
          _successMessage = "Kayıt başarılı! Giriş ekranına yönlendiriliyorsunuz...";
        });
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (result is Map<String, dynamic> && result.containsKey('errors')) {
        setState(() {
          _fieldErrors = Map<String, List<String>>.from(
            result['errors'].map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ),
          );
        });
      } else {
        setState(() {
          _errorMessage = "Kayıt başarısız. Bilgileri kontrol edin.";
        });
      }
    }
  }

  String? _fieldError(String key) {
    return _fieldErrors.containsKey(key) ? _fieldErrors[key]!.join('\n') : null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Bu alan zorunlu';
    final regex = RegExp(r"^[a-zA-ZğüşöçıİĞÜŞÖÇ\s]+$");
    if (!regex.hasMatch(value)) return 'Sadece harf kullanın';
    return null;
  }

  String? _validateGmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta girin';
    }

    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    if (!gmailRegex.hasMatch(value)) {
      return 'Sadece geçerli bir Gmail adresi girin';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E6), // Bej arka plan
      appBar: AppBar(
        backgroundColor: const Color(0xFF800000), // Bordo
        title: const Text(
          'Kayıt Ol',
          style: TextStyle(
            color: Color(0xFFFFCDD2), // Açık bordo yazı
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.person, size: 100, color: Color(0xFF800000)),
              const SizedBox(height: 16),
              _buildInput(_firstNameController, 'Ad', _validateName, _fieldError("FirstName")),
              _buildInput(_lastNameController, 'Soyad', _validateName, _fieldError("LastName")),
              _buildInput(
                _userNameController,
                'Kullanıcı Adı',
                (value) => value == null || value.isEmpty ? 'Kullanıcı adı girin' : null,
                _fieldError("UserName"),
              ),
              _buildInput(_emailController, 'E-posta', _validateGmail, _fieldError("Email")),
              _buildInput(
                _phoneNumberController,
                'Telefon',
                (value) => value == null || value.isEmpty ? 'Telefon girin' : null,
                _fieldError("PhoneNumber"),
              ),
              _buildInput(
                _passwordController,
                'Şifre',
                (value) => value == null || value.length < 6 ? 'En az 6 karakter' : null,
                _fieldError("Password"),
                obscure: true,
              ),
              _buildInput(
                _confirmPasswordController,
                'Şifre (Tekrar)',
                (value) =>
                    value != _passwordController.text ? 'Şifreler uyuşmuyor' : null,
                null,
                obscure: true,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              if (_successMessage != null)
                Text(_successMessage!, style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000), // Bordo
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: _register,
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    String? Function(String?)? validator,
    String? errorText, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: validator,
      ),
    );
  }
}
