// Halaman Format pemesanan meja

// lib/screens/booking_form_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm;

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_selectedStartTime ?? TimeOfDay.now())
          : (_selectedEndTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final table = ModalRoute.of(context)?.settings.arguments as dm.Table?;
    final isQueue = table?.isOccupied ?? false;

    return Scaffold(
      appBar: AppBar(title: Text('Booking ${table?.number ?? 'Meja'}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isQueue
                  ? 'Table is occupied. You will join the Queue.'
                  : 'Table is available. Proceed to book.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isQueue ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            _buildInputField(
              label: 'Guest Name',
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            _buildInputField(
              label: 'Phone Number',
              controller: _phoneController,
              icon: Icons.phone,
            ),

            // Pemilihan Tanggal
            _buildTimePickerTile(
              label: 'Booking Date',
              icon: Icons.calendar_today,
              value: _selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              onTap: () => _selectDate(context),
            ),

            // Pemilihan Waktu
            _buildTimePickerTile(
              label: 'Start Time',
              icon: Icons.access_time,
              value: _selectedStartTime?.format(context) ?? 'Select Time',
              onTap: () => _selectTime(context, true),
            ),
            _buildTimePickerTile(
              label: 'End Time',
              icon: Icons.access_time_filled,
              value: _selectedEndTime?.format(context) ?? 'Select Time',
              onTap: () => _selectTime(context, false),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //  Validasi sederhana
                  if (_nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter guest name")),
                    );
                    return;
                  }

                  //  Update Status Meja: Langsung jadi merah
                  if (!isQueue && table != null) {
                    table.isOccupied = true; // UBAH JADI MERAH
                  }

                  //  Kirim data lengkap ke Payment Summary
                  Navigator.pushNamed(
                    context,
                    '/payment_summary',
                    arguments: {
                      'isQueue': isQueue,
                      'table': table, // Bawa data meja
                      'guestName': _nameController.text,
                      'date': _selectedDate,
                      'startTime': _selectedStartTime,
                      'endTime': _selectedEndTime,
                    },
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(isQueue ? 'Join Queue' : 'Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile({
    required String label,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
