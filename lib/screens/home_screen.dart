// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF5D4037);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.coffee, size: 28, color: primaryColor),
                    SizedBox(width: 8),
                    Text(
                      'Café Reserve',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Find and book your perfect spot',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),

                const SizedBox(height: 30),

                // Card 1: Book a Table
                ActionCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Book a Table',
                  subtitle: 'Reserve your favorite spot',
                  onTap: () => Navigator.pushNamed(context, '/choose_table'),
                ),
                const SizedBox(height: 15),

                // Card 2: View Queue
                ActionCard(
                  icon: Icons.group_outlined,
                  title: 'View Queue',
                  subtitle: 'Check waiting times',
                  onTap: () => Navigator.pushNamed(context, '/view_queue'),
                ),
                const SizedBox(height: 15),

                // Card 3: My Bookings
                ActionCard(
                  icon: Icons.bookmark_border,
                  title: 'My Bookings',
                  subtitle: '1 reservation',
                  onTap: () => Navigator.pushNamed(context, '/my_bookings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
