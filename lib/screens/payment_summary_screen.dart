// lib/screens/payment_summary_screen.dart
import 'package:flutter/material.dart';

// FIX: Pindahkan definisi warna ke sini agar dapat diakses oleh semua method
const Color primaryColor = Color(0xFF5D4037);

class PaymentSummaryScreen extends StatefulWidget {
  const PaymentSummaryScreen({super.key});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  String? _selectedPaymentMethod;
  final double _totalAmount = 50.00;

  @override
  Widget build(BuildContext context) {
    // const Color primaryColor = Color(0xFF5D4037); // Dihapus karena sudah di atas

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Ringkasan Booking ---
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Table Number', 'T3'),
            _buildDetailRow('Time Slot', '14:00 - 16:00'),
            _buildDetailRow('Guest Name', 'Placeholder Name'),
            const Divider(height: 30),

            // --- Rincian Biaya ---
            const Text(
              'Cost Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Deposit Fee', 'IDR 50.000', isTotal: false),

            const Divider(height: 30),

            // --- Total Pembayaran ---
            _buildDetailRow(
              'TOTAL PAYMENT',
              'IDR ${_totalAmount.toStringAsFixed(3)}',
              isTotal: true,
            ),
            const SizedBox(height: 30),

            // --- Pilih Metode Pembayaran (Sesuai Foto 5) ---
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),

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
              title: 'Bank Transfer (BCA)',
              icon: Icons.credit_card,
              value: 'BCA',
            ),

            const SizedBox(height: 40),

            // Tombol Konfirmasi dan Bayar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () {
                        _startPaymentProcess(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Confirm & Pay',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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

  void _startPaymentProcess(BuildContext context) {
    // Foto 6: Loading screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: primaryColor,
              ), // FIX: primaryColor sekarang terdefinisi
              SizedBox(height: 20),
              Text('Processing Payment...', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _showSuccessPopup(context);
    });
  }

  void _showSuccessPopup(BuildContext context) {
    // Foto 7: Success screen
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
              const Icon(Icons.check_circle, color: Colors.green, size: 70),
              const SizedBox(height: 15),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
