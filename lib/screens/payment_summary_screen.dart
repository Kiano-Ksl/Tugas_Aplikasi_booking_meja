// lib/screens/payment_summary_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm; // Gudang data
import '../data/booking_model.dart'; // Cetakan data booking

// Warna dasar coklat (kopi)
const Color primaryColor = Color(0xFF5D4037);

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  // Variabel buat nyimpen metode pembayaran yang dipilih (OVO/Gopay/BCA)
  String? _selectedPaymentMethod;

  // Harga total (ceritanya flat rate 50rb buat booking)
  final double _totalAmount = 50.000;

  @override
  Widget build(BuildContext context) {
    // --- TANGKAP DATA DARI HALAMAN SEBELUMNYA ---
    // Ini cara ngambil "koper" data yang dikirim dari Booking Form
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Bongkar isi kopernya satu-satu
    final bool isQueue = args['isQueue']; // Status: Antri atau Booking biasa?
    final dm.Table? table = args['table'];
    final String guestName = args['guestName'];
    final DateTime date = args['date'] ?? DateTime.now();
    final TimeOfDay startTime = args['startTime'] ?? TimeOfDay.now();
    final TimeOfDay endTime = args['endTime'] ?? TimeOfDay.now();

    // Bikin format jam "10:00 - 12:00" biar rapi
    final String timeSlot =
        '${startTime.format(context)} - ${endTime.format(context)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Pembayaran')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: DETAIL BOOKING ---
            const Text(
              'Detail Pesanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // Panggil fungsi _buildDetailRow biar kodingan gak kepanjangan
            _buildDetailRow('Nomor Meja', table?.number ?? '-'),
            _buildDetailRow('Waktu', timeSlot),
            _buildDetailRow('Atas Nama', guestName),
            const Divider(height: 30), // Garis pemisah tipis
            // --- BAGIAN 2: RINCIAN BIAYA ---
            const Text(
              'Rincian Biaya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Biaya Deposit', 'Rp 50.000', isTotal: false),
            const Divider(height: 30),

            _buildDetailRow(
              'TOTAL BAYAR',
              'Rp ${_totalAmount.toStringAsFixed(3)}',
              isTotal: true,
            ),
            const SizedBox(height: 30),

            // --- BAGIAN 3: PILIH METODE BAYAR ---
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // Pilihan dompet digital / bank
            _buildPaymentOption(
              title: 'OVO',
              icon: Icons.phone_android,
              value: 'OVO',
            ),
            _buildPaymentOption(
              title: 'GoPay',
              icon: Icons.phone_android,
              value: 'GoPay',
            ),
            _buildPaymentOption(
              title: 'Transfer Bank (BCA)',
              icon: Icons.credit_card,
              value: 'BCA',
            ),

            const SizedBox(height: 40),

            // --- TOMBOL KONFIRMASI ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Kalau belum pilih metode bayar, tombolnya mati (null)
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () {
                        // 1. Simpan data ke database aplikasi
                        _processBookingData(
                          table,
                          guestName,
                          date,
                          startTime,
                          endTime,
                          isQueue,
                        );
                        // 2. Mulai animasi loading bayar
                        _startPaymentProcess(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Konfirmasi & Bayar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA MENYIMPAN DATA (PENTING!) ---
  void _processBookingData(
    dm.Table? table,
    String name,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
    bool isQueue,
  ) {
    // Bikin ID unik pakai waktu sekarang (biar gak ada yang kembar)
    // Contoh ID: B9812371
    String uniqueId =
        'B${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    // Bungkus semua data jadi satu paket (BookingModel)
    final newBooking = BookingModel(
      id: uniqueId,
      tableNumber: table?.number ?? '?',
      guestName: name,
      date: date,
      startTime: start.format(context),
      endTime: end.format(context),
      totalAmount: 50.000,
      // Kalau antri statusnya 'Queueing', kalau gak antri 'Confirmed'
      status: isQueue ? 'Queueing' : 'Confirmed',
      qrCodeData:
          'https://kafereserve.com/ticket/$uniqueId', // Link QR pura-pura
    );

    // Masukin ke list utama di DataManager
    dm.DataManager.userBookings.add(newBooking);

    // Kalau statusnya antri, masukin juga ke sistem antrian (Linked List)
    if (isQueue) {
      dm.DataManager.bookingQueue.enqueue(newBooking);
    }

    // --- SAVE PERMANEN ---
    // Panggil fungsi sakti biar data gak ilang pas aplikasi ditutup
    dm.DataManager.saveBookings();
  }

  // --- WIDGET BANTUAN BUAT BIKIN BARIS RINCIAN ---
  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.red.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BANTUAN BUAT PILIHAN BAYAR ---
  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        // Kalau dipilih, garis pinggirnya biru. Kalau enggak, abu-abu.
        side: BorderSide(
          color: _selectedPaymentMethod == value
              ? Colors.blue
              : Colors.grey.shade300,
          width: _selectedPaymentMethod == value ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        // Radio button di kanan
        trailing: Radio<String>(
          value: value,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? val) {
            setState(() {
              _selectedPaymentMethod = val;
            });
          },
        ),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
    );
  }

  // --- ANIMASI LOADING PEMBAYARAN ---
  void _startPaymentProcess(BuildContext context) {
    // Munculin popup loading muter-muter
    showDialog(
      context: context,
      barrierDismissible: false, // Gak bisa ditutup dengan klik luar
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: primaryColor,
              ), // Lingkaran loading
              SizedBox(height: 20),
              Text('Memproses Pembayaran...', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );

    // Pura-pura nunggu 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Tutup loading
      _showSuccessPopup(context); // Munculin popup sukses
    });
  }

  // --- POPUP SUKSES BAYAR ---
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 70,
              ), // Centang ijo gede
              const SizedBox(height: 15),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Silakan cek tiket kamu di menu "Pesanan Saya"',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup popup
                    // Balik ke Home dan hapus semua history halaman sebelumnya (biar gak bisa back ke payment)
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Kembali ke Menu Utama'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
