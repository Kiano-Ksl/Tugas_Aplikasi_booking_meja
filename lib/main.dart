// lib/main.dart
import 'package:flutter/material.dart'; // Panggil paket utama Flutter buat bikin UI

// Import semua halaman yang kita butuhin biar si main.dart kenal
import 'auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/choose_table_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/payment_summary_screen.dart';
import 'screens/my_bookings_screen.dart';
import 'screens/splash_screen.dart';
import 'data/data_manager.dart'; // Import gudang data kita

// Fungsi utama yang jalan pertama kali saat aplikasi dibuka
void main() async {
  // Kita suruh Flutter siap-siap dulu sebelum load data
  WidgetsFlutterBinding.ensureInitialized();

  // Coba ambil data booking dari memori HP (SharedPreferences)
  await DataManager.loadBookings();

  // Kalau data udah siap, baru jalanin aplikasinya
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Warna coklat kopi, warna khas aplikasi kita
  static const Color primaryColor = Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Reservasi Kafe', // Ganti jadi Bahasa Indonesia
      debugShowCheckedModeBanner:
          false, // Ilangin pita 'Debug' yang miring di pojok kanan atas
      // Atur tema biar kita gak capek ngewarnain satu-satu
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ), // Warna dasar ambil dari biji kopi
        scaffoldBackgroundColor: const Color(
          0xFFF7F4EF,
        ), // Warna background krem biar adem
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor, // Header warnanya coklat
          foregroundColor: Colors.white, // Teks di header warnanya putih
        ),
        useMaterial3: true, // Pake gaya desain Android terbaru
      ),

      // Halaman yang pertama kali muncul pas buka aplikasi
      initialRoute: '/splash',

      // Peta navigasi: Daftar alamat halaman biar bisa pindah-pindah
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(), // Halaman Masuk
        '/home': (context) => const HomeScreen(), // Halaman Utama
        '/choose_table': (context) =>
            const ChooseTableScreen(isBooking: true), // Buat milih meja
        '/view_queue': (context) => const ChooseTableScreen(
          isBooking: false,
        ), // Buat liat antrian doang
        '/booking_form': (context) =>
            const BookingFormScreen(), // Formulir pesan
        '/payment_summary': (context) =>
            const PaymentSummaryScreen(), // Halaman bayar
        '/my_bookings': (context) =>
            const MyBookingsScreen(), // Riwayat pesanan
      },
    );
  }
}
