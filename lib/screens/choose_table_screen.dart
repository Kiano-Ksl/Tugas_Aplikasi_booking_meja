// lib/screens/choose_table_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart'
    as dm; // Panggil gudang data, kita singkat jadi 'dm'

class ChooseTableScreen extends StatefulWidget {
  // Variabel ini buat nentuin: User ke sini mau Booking (true) atau cuma liat Antrian (false)?
  final bool isBooking;

  const ChooseTableScreen({super.key, required this.isBooking});

  @override
  State<ChooseTableScreen> createState() => _ChooseTableScreenState();
}

class _ChooseTableScreenState extends State<ChooseTableScreen> {
  // Fungsi buat bikin kotak meja satu per satu
  Widget _buildTableItem(BuildContext context, dm.Table table) {
    // Tentuin warna: Kalau penuh (Occupied) merah, kalau kosong hijau
    Color statusColor = table.isOccupied
        ? Colors.red.shade700
        : Colors.green.shade700;

    // Itung berapa orang yang lagi ngantri di meja ini
    int queueCount = dm.DataManager.userBookings
        .where((b) => b.tableNumber == table.number && b.status == 'Queueing')
        .length;

    // Apa yang terjadi kalau meja dipencet?
    void handleTap() {
      if (!widget.isBooking)
        return; // Kalau cuma mode liat antrian, gak bisa dipencet

      if (table.isOccupied) {
        // Kalau meja penuh, tawarin masuk antrian (Waiting List)
        _showQueueDialog(context, table);
      } else {
        // Kalau meja kosong, langsung isi formulir booking
        Navigator.pushNamed(context, '/booking_form', arguments: table);
      }
    }

    return InkWell(
      onTap: handleTap, // Pasang fungsi tap di sini
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, // Warna dasar kotak putih
          borderRadius: BorderRadius.circular(10), // Sudut tumpul
          border: Border.all(
            color: Colors.grey.shade300,
          ), // Garis pinggir tipis
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5),
          ], // Bayangan dikit
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Isi di tengah-tengah
          children: [
            Icon(
              Icons.chair,
              size: 40,
              color: statusColor,
            ), // Ikon kursi warnanya ikut status
            const SizedBox(height: 10),
            Text(
              'Meja ${table.number}', // Misal: Meja T1
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Kapasitas: ${table.capacity}', // Info muat berapa orang
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),

            // TULISAN STATUS DI BAWAH
            Text(
              table.isOccupied
                  ? 'Penuh (Antri: $queueCount)' // Kalau penuh, kasih tau antriannya
                  : 'Tersedia', // Kalau kosong
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Munculin popup kalau user maksa pilih meja yang merah
  void _showQueueDialog(BuildContext context, dm.Table table) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Meja ${table.number} Lagi Penuh'),
          content: const Text(
            'Kamu mau masuk daftar tunggu (Waiting List) buat meja ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Tombol Batal
              child: const Text('Gak Jadi'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup popup
                // Lanjut ke form booking tapi statusnya nanti jadi 'Queueing'
                Navigator.pushNamed(context, '/booking_form', arguments: table);
              },
              child: const Text('Ikut Antri'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Judul halaman tergantung mode (Booking atau cuma Liat)
    String title = widget.isBooking ? 'Pilih Meja' : 'Status Antrian';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Penjelasan singkat di atas
            Text(
              widget.isBooking
                  ? 'Pilih meja hijau buat booking, atau meja merah buat antri.'
                  : 'Pantau ketersediaan meja secara real-time.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // GridView buat nampilin meja kotak-kotak (2 kolom ke samping)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kotak per baris
                  childAspectRatio: 1, // Kotaknya persegi (1:1)
                  crossAxisSpacing: 15, // Jarak ke samping
                  mainAxisSpacing: 15, // Jarak ke bawah
                ),
                itemCount: dm
                    .DataManager
                    .cafeTables
                    .length, // Jumlah meja ngambil dari data
                itemBuilder: (context, index) {
                  return _buildTableItem(
                    context,
                    dm.DataManager.cafeTables[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
