// lib/auth/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const Color primaryColor = Color(0xFF5D4037);
  static const Color accentColor = Color(0xFFD7CCC8);
  static const Color backgroundColor = Color(0xFFF7F4EF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.coffee, size: 80, color: primaryColor),
                const SizedBox(height: 10),
                const Text(
                  'Selamat Datang', // GANTI: Welcome Back
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                // Tombol Google
                _buildSignInButton(
                  context,
                  'Lanjut dengan Google',
                  true,
                ), // GANTI BAHASA
                const SizedBox(height: 20),
                const Text(
                  'ATAU',
                  style: TextStyle(color: Colors.grey),
                ), // GANTI BAHASA
                const SizedBox(height: 20),

                // Input Email
                _buildTextField(
                  hint: 'Alamat Email', // GANTI BAHASA
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 15),

                // Input Password
                _buildTextField(
                  hint: 'Kata Sandi', // GANTI BAHASA
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 30),

                // Tombol Masuk Utama
                _buildSignInButton(context, 'Masuk', false), // GANTI BAHASA
                const SizedBox(height: 40),

                // Link Buat Akun
                _buildCreateAccountLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget bantuan untuk bikin tombol biar kodenya rapi
  Widget _buildSignInButton(BuildContext context, String text, bool isGoogle) {
    return SizedBox(
      width: double.infinity,
      child: isGoogle
          ? OutlinedButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              icon: const Icon(Icons.person, color: Colors.blue),
              label: Text(text, style: const TextStyle(fontSize: 16)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[800],
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  // Widget bantuan untuk bikin kotak input
  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: primaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  // Widget bantuan untuk link "Buat Akun"
  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Belum punya akun?", // GANTI BAHASA
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Buat Akun', // GANTI BAHASA
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
