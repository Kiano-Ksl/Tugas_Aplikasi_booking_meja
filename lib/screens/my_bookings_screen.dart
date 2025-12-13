// Halaman booking saya

// lib/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm;
import '../data/booking_model.dart';
import 'booking_ticket_screen.dart';

// --- WIDGET CARD UNTUK SETIAP BOOKING ---
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onComplete; // Callback saat tombol Complete ditekan
  final VoidCallback onDelete; // Callback saat tombol Delete ditekan (BARU)

  const BookingCard({
    super.key,
    required this.booking,
    required this.onComplete,
    required this.onDelete,
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

            // Detail Booking
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
                // Tombol View Ticket (Selalu muncul)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingTicketScreen(booking: booking),
                        ),
                      );
                    },
                    child: const Text("View Ticket"),
                  ),
                ),
                const SizedBox(width: 10),

                // LOGIKA TOMBOL KANAN:
                // Jika Confirmed -> Tombol "Complete"
                // Jika Completed -> Tombol "Delete" (BARU)
                if (booking.status == 'Confirmed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Complete"),
                    ),
                  )
                else if (booking.status == 'Completed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDelete, // Panggil fungsi hapus
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700, // Warna Merah
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Delete"),
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

// --- MY BOOKINGS SCREEN UTAMA ---
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
                // Ambil booking berdasarkan index
                final booking = bookings[index];

                return BookingCard(
                  booking: booking,
                  onComplete: () {
                    // LOGIKA COMPLETE
                    setState(() {
                      dm.DataManager.completeBooking(booking);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order completed! Queue updated."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  onDelete: () {
                    // LOGIKA DELETE (BARU)
                    // Tampilkan dialog konfirmasi dulu agar tidak terhapus tidak sengaja
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete History"),
                        content: const Text(
                          "Are you sure you want to delete this booking history?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialog
                              setState(() {
                                // Hapus dari list di DataManager
                                dm.DataManager.userBookings.remove(booking);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Booking history deleted."),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
