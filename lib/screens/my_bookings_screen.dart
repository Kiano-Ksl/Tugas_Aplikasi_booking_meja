// lib/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm;
import '../data/booking_model.dart';

// --- WIDGET CARD UNTUK SETIAP BOOKING ---
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onComplete; // Callback saat tombol ditekan

  const BookingCard({
    super.key,
    required this.booking,
    required this.onComplete,
  });

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
      case 'Completed':
        statusColor = Colors.grey;
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
                  'ID: ${booking.id}',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
            const Divider(),

            // Detail Booking (Menggunakan ListTile agar lebih rapi)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.table_bar,
                color: primaryColor,
                size: 30,
              ),
              title: Text(
                'Table ${booking.tableNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${booking.guestName}\n${booking.startTime} - ${booking.endTime}',
              ),
            ),

            // TOMBOL AKSI
            Row(
              children: [
                // Tombol QR (Placeholder)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("QR Code displayed!")),
                      );
                    },
                    child: const Text("QR Code"),
                  ),
                ),
                const SizedBox(width: 10),

                // TOMBOL COMPLETE (Hanya muncul jika status Confirmed)
                // Ini adalah kunci simulasi FIFO: Menyelesaikan pesanan saat ini
                if (booking.status == 'Confirmed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete, // Panggil fungsi callback
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Complete"),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- MY BOOKINGS SCREEN UTAMA (Sekarang Stateful) ---
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Mengambil data langsung dari DataManager
    final List<BookingModel> bookings = dm.DataManager.userBookings;

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(child: Text('No bookings yet. Go book a table!'))
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return BookingCard(
                  booking: bookings[index],
                  onComplete: () {
                    // LOGIKA INTI: COMPLETE BOOKING
                    // Menggunakan setState agar tampilan langsung berubah (rebuild)
                    setState(() {
                      // Panggil logika di DataManager untuk mengubah status
                      // dan memicu antrian berikutnya (FIFO)
                      dm.DataManager.completeBooking(bookings[index]);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order completed! Queue updated."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
