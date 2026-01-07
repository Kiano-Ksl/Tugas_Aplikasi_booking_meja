// lib/screens/home_screen.dart
import 'package:flutter/material.dart'; // Wajib ada buat UI
import '../widgets/action_card.dart'; // Kita butuh widget kartu buatan sendiri

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar itu header di atas yang warna coklat
      appBar: AppBar(
        title: const Text('Menu Utama'), // Judul header
        centerTitle: true, // Biar judulnya pas di tengah
        automaticallyImplyLeading:
            false, // Ilangin tombol back, biar gak bisa balik ke login
      ),

      // Bagian badannya
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Kasih jarak dikit dari pinggir
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Melar ke samping menuhin layar
          children: [
            // Sapaan buat user
            const Text(
              'Halo, Mau Ngapain Hari Ini?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // Spasi kosong biar gak mepet
            // --- KARTU MENU 1: PESAN MEJA ---
            ActionCard(
              title: 'Pesan Meja', // Judul Kartu
              subtitle: 'Cari dan booking meja kosong', // Keterangan
              icon: Icons.table_restaurant, // Ikon meja
              onTap: () {
                // Kalau dipencet, lari ke halaman pilih meja
                Navigator.pushNamed(context, '/choose_table');
              },
            ),

            const SizedBox(height: 20), // Jarak antar kartu
            // --- KARTU MENU 2: LIHAT ANTRIAN ---
            ActionCard(
              title: 'Cek Antrian',
              subtitle: 'Lihat status kepadatan kafe',
              icon: Icons.people_alt, // Ikon orang rame
              onTap: () {
                // Ke halaman antrian (sebenernya sama kayak pilih meja, cuma beda mode)
                Navigator.pushNamed(context, '/view_queue');
              },
            ),

            const SizedBox(height: 20),

            // --- KARTU MENU 3: PESANAN SAYA ---
            ActionCard(
              title: 'Pesanan Saya',
              subtitle: 'Cek riwayat booking kamu',
              icon: Icons.receipt_long, // Ikon struk/kertas panjang
              onTap: () {
                Navigator.pushNamed(context, '/my_bookings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
