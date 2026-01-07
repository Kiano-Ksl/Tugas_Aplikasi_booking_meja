// lib/screens/my_bookings_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm; // Gudang data
import '../data/booking_model.dart'; // Cetakan data
import 'booking_ticket_screen.dart'; // Halaman detail tiket

// --- WIDGET KARTU BOOKING ---
// Kita pisahin widget kartu ini biar kodingan di bawah gak numpuk
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback
  onComplete; // Apa yang terjadi pas tombol "Selesai" dipencet
  final VoidCallback onDelete; // Apa yang terjadi pas tombol "Hapus" dipencet

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

    // Tentukan warna status biar gampang dikenali mata
    switch (booking.status) {
      case 'Confirmed':
        statusColor = Colors.green.shade700; // Hijau: Aman, udah dapet meja
        break;
      case 'Queueing':
        statusColor = Colors.orange.shade700; // Oranye: Masih ngantri
        break;
      case 'Completed':
        statusColor = Colors.grey; // Abu-abu: Udah kelar makan
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3, // Bayangan kartu
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // --- HEADER KARTU (Status & ID) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Label Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(
                      0.1,
                    ), // Warnanya transparan dikit
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    booking.status == 'Confirmed'
                        ? 'Terkonfirmasi'
                        : booking.status == 'Queueing'
                        ? 'Dalam Antrian'
                        : 'Selesai',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ID Booking
                Text(
                  'ID: ${booking.id}',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
            const Divider(), // Garis pemisah
            // --- ISI KARTU (Info Meja & Jam) ---
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.table_bar, // Ikon meja
                color: primaryColor,
                size: 30,
              ),
              title: Text(
                'Meja ${booking.tableNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${booking.guestName}\n${booking.startTime} - ${booking.endTime}',
              ),
            ),

            // --- TOMBOL AKSI ---
            Row(
              children: [
                // Tombol "Lihat Tiket" (Selalu muncul)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Buka halaman detail tiket (QR Code)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingTicketScreen(booking: booking),
                        ),
                      );
                    },
                    child: const Text("Lihat Tiket"),
                  ),
                ),
                const SizedBox(width: 10),

                // LOGIKA TOMBOL KANAN: Beda status, beda tombolnya
                if (booking.status == 'Confirmed')
                  // Kalau lagi makan -> Muncul tombol "Selesai"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Selesai"),
                    ),
                  )
                else if (booking.status == 'Completed')
                  // Kalau udah kelar -> Muncul tombol "Hapus" (Merah)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700, // Merah bahaya
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Hapus"),
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

// --- LAYAR UTAMA DAFTAR PESANAN ---
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Ambil semua data booking dari gudang
    final List<BookingModel> bookings = dm.DataManager.userBookings;

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      // Kalau datanya kosong, tampilin teks di tengah
      body: bookings.isEmpty
          ? const Center(
              child: Text('Belum ada pesanan nih. Yuk booking dulu!'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                // Ambil booking satu per satu berdasarkan urutan
                final booking = bookings[index];

                return BookingCard(
                  booking: booking,
                  // --- LOGIKA TOMBOL SELESAI ---
                  onComplete: () {
                    setState(() {
                      // Ubah status jadi 'Completed' & update antrian meja
                      dm.DataManager.completeBooking(booking);
                    });
                    // Kasih notif kecil di bawah
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Terima kasih! Meja sekarang kosong."),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  // --- LOGIKA TOMBOL HAPUS ---
                  onDelete: () {
                    // TANYA DULU: Yakin mau hapus? (Penting biar gak kepencet)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Hapus Riwayat"),
                        content: const Text(
                          "Yakin mau hapus riwayat booking ini? Datanya gak bisa balik lho.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Batal
                            child: const Text("Gak Jadi"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup popup tanya jawab
                              setState(() {
                                // Hapus data dari list di memori
                                dm.DataManager.userBookings.remove(booking);
                                // SIMPAN PERUBAHAN KE MEMORI HP (Permanen)
                                dm.DataManager.saveBookings();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Riwayat berhasil dihapus."),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text(
                              "Hapus",
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
