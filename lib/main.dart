// lib/main.dart
import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/choose_table_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/payment_summary_screen.dart';
import 'screens/my_bookings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryColor = Color(0xFF5D4037);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Reserve App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color(0xFFF7F4EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/choose_table': (context) => const ChooseTableScreen(isBooking: true),
        '/view_queue': (context) => const ChooseTableScreen(isBooking: false),
        '/booking_form': (context) => const BookingFormScreen(),
        '/payment_summary': (context) => const PaymentSummaryScreen(),
        '/my_bookings': (context) =>
            const MyBookingsScreen(), // Memanggil kelas yang di-import
      },
    );
  }
}
