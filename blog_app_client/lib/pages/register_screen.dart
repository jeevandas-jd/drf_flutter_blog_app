import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;
  String? error;

  Future<void> register() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/register/'), // use your backend IP
      body: {
        'username': _username.text,
        'password': _password.text,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Registration successful, go to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        error = "Registration failed: ${response.body}";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: const Color(0xFF06923E),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _username,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06923E),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
