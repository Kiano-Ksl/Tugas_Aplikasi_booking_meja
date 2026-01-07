// lib/screens/payment_summary_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm;
import '../data/booking_model.dart';

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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final bool isQueue = args['isQueue'];
    final dm.Table? table = args['table'];
    final String guestName = args['guestName'];
    final DateTime date = args['date'] ?? DateTime.now();
    final TimeOfDay startTime = args['startTime'] ?? TimeOfDay.now();
    final TimeOfDay endTime = args['endTime'] ?? TimeOfDay.now();

    final String timeSlot =
        '${startTime.format(context)} - ${endTime.format(context)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            _buildDetailRow('Table Number', table?.number ?? '-'),
            _buildDetailRow('Time Slot', timeSlot),
            _buildDetailRow('Guest Name', guestName),
            const Divider(height: 30),

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

            _buildDetailRow(
              'TOTAL PAYMENT',
              'IDR ${_totalAmount.toStringAsFixed(3)}',
              isTotal: true,
            ),
            const SizedBox(height: 30),

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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () {
                        _processBookingData(
                          table,
                          guestName,
                          date,
                          startTime,
                          endTime,
                          isQueue,
                        );
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

  void _processBookingData(
    dm.Table? table,
    String name,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
    bool isQueue,
  ) {
    final newBooking = BookingModel(
      id: 'B${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      tableNumber: table?.number ?? '?',
      guestName: name,
      date: date,
      startTime: start.format(context),
      endTime: end.format(context),
      totalAmount: 50.00,
      status: isQueue ? 'Queueing' : 'Confirmed',
      qrCodeData: 'https://qr.code/dummy',
    );

    dm.DataManager.userBookings.add(newBooking);

    if (isQueue) {
      dm.DataManager.bookingQueue.enqueue(newBooking);
    }

    // --- SIMPAN DATA AGAR TIDAK HILANG ---
    dm.DataManager.saveBookings();
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
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
