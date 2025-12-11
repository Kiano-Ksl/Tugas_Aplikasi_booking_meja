// lib/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm; // Menggunakan prefix 'dm'
import '../data/booking_model.dart';

// --- WIDGET CARD UNTUK SETIAP BOOKING ---
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF5D4037);
    Color statusColor;

    // Menentukan warna status
    switch (booking.status) {
      case 'Confirmed':
        statusColor = Colors.green.shade700;
        break;
      case 'Queueing':
        statusColor = Colors.orange.shade700;
        break;
      case 'Cancelled':
        statusColor = Colors.red.shade700;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status dan ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Booking ID: ${booking.id}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            const Divider(height: 20),

            // Detail Booking
            Row(
              children: [
                const Icon(Icons.table_bar, color: primaryColor, size: 30),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Table ${booking.tableNumber}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Guest: ${booking.guestName}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Waktu dan Tanggal
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  '${booking.startTime} - ${booking.endTime}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  '${booking.date.day}/${booking.date.month}/${booking.date.year}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Tombol QR Code/Lihat Detail
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Logika untuk menampilkan QR code
                },
                icon: const Icon(Icons.qr_code_2, color: Colors.blue),
                label: const Text('View QR Code / Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MY BOOKINGS SCREEN UTAMA ---
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Memastikan pemanggilan properti 'userBookings' melalui prefix 'dm'
    final List<BookingModel> bookings = dm.DataManager.userBookings;

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('You have no active bookings.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return BookingCard(booking: bookings[index]);
              },
            ),
    );
  }
}
