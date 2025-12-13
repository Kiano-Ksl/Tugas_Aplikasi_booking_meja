// Halaman Tiket

// lib/screens/booking_ticket_screen.dart
import 'package:flutter/material.dart';
import '../data/booking_model.dart';

class BookingTicketScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingTicketScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF5D4037);
    const Color backgroundColor = Color(0xFFEFEbe2); // Warna krem background

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Ticket', style: TextStyle(fontSize: 18)),
            Text(
              'Your reservation details',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- KARTU TIKET ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. Gambar QR Code (Menggunakan Icon besar sebagai simulasi)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 150,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 2. Detail Data
                    _buildTicketItem(
                      icon: Icons.location_on,
                      label: 'Table Number',
                      value: 'Table ${booking.tableNumber}',
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 30),

                    _buildTicketItem(
                      icon: Icons.person,
                      label: 'Guest Name',
                      value: booking.guestName,
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 30),

                    _buildTicketItem(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value:
                          '${booking.date.day}-${booking.date.month}-${booking.date.year}',
                      primaryColor: primaryColor,
                    ),
                    const Divider(height: 30),

                    _buildTicketItem(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: '${booking.startTime} - ${booking.endTime}',
                      primaryColor: primaryColor,
                    ),

                    const SizedBox(height: 30),

                    // 3. Status Confirmed
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Footer Text
              const Text(
                'Please arrive 5-10 minutes before\nyour scheduled time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketItem({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: primaryColor),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
