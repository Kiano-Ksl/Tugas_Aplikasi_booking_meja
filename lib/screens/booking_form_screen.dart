// lib/screens/booking_form_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm;
import '../data/booking_model.dart';

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

  // --- KONFIGURASI BATASAN ---
  final int _minNameLength = 3;
  final int _minPhoneLength = 10;
  final int _minDurationMinutes = 60;
  final int _maxDurationMinutes = 180;

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
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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

  int _toMinutes(TimeOfDay time) {
    return (time.hour * 60) + time.minute;
  }

  // --- FUNGSI CEK BENTROK JADWAL ---
  bool _isTimeSlotAvailable(
    String tableNumber,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    int newStart = _toMinutes(start);
    int newEnd = _toMinutes(end);

    for (var existingBooking in dm.DataManager.userBookings) {
      // 1. Cek Meja
      if (existingBooking.tableNumber != tableNumber) continue;

      // 2. Cek Tanggal
      bool isSameDay =
          existingBooking.date.year == date.year &&
          existingBooking.date.month == date.month &&
          existingBooking.date.day == date.day;

      if (!isSameDay) continue;

      // 3. Cek Status
      if (existingBooking.status == 'Cancelled' ||
          existingBooking.status == 'Completed')
        continue;

      // Parsing waktu dari database
      TimeOfDay existingStartObj = _parseTime(existingBooking.startTime);
      TimeOfDay existingEndObj = _parseTime(existingBooking.endTime);

      int existingStart = _toMinutes(existingStartObj);
      int existingEnd = _toMinutes(existingEndObj);

      // 4. Rumus Bentrok
      if (newStart < existingEnd && newEnd > existingStart) {
        return false; // Ada tabrakan waktu!
      }
    }

    return true; // Aman
  }

  TimeOfDay _parseTime(String timeString) {
    try {
      final cleanString = timeString.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
      final parts = cleanString.split(":");

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      if (timeString.toUpperCase().contains("PM") && hour < 12) {
        hour += 12;
      }
      if (timeString.toUpperCase().contains("AM") && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now();
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
              isNumber: true,
            ),

            _buildTimePickerTile(
              label: 'Booking Date',
              icon: Icons.calendar_today,
              value: _selectedDate == null
                  ? 'Select Date'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              onTap: () => _selectDate(context),
            ),

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
                  // --- VALIDASI INPUT ---
                  if (_nameController.text.length < _minNameLength) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Name must be at least $_minNameLength letters",
                        ),
                      ),
                    );
                    return;
                  }
                  if (_phoneController.text.length < _minPhoneLength) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Phone must be at least $_minPhoneLength digits",
                        ),
                      ),
                    );
                    return;
                  }
                  if (_selectedDate == null ||
                      _selectedStartTime == null ||
                      _selectedEndTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select date and time duration"),
                      ),
                    );
                    return;
                  }

                  // --- VALIDASI DURASI ---
                  int startMin = _toMinutes(_selectedStartTime!);
                  int endMin = _toMinutes(_selectedEndTime!);
                  int duration = endMin - startMin;

                  if (endMin <= startMin) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("End time must be after start time"),
                      ),
                    );
                    return;
                  }

                  if (duration < _minDurationMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Minimum booking duration is 1 hour"),
                      ),
                    );
                    return;
                  }

                  if (duration > _maxDurationMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Maximum booking duration is 3 hours"),
                      ),
                    );
                    return;
                  }

                  // --- VALIDASI BENTROK (OVERLAP) ---
                  if (table != null) {
                    bool available = _isTimeSlotAvailable(
                      table.number,
                      _selectedDate!,
                      _selectedStartTime!,
                      _selectedEndTime!,
                    );

                    if (!available) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Time slot conflict! This table is booked at that time.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  // --- PERBAIKAN: JANGAN UBAH STATUS MEJA DI SINI ---
                  // Kode table.isOccupied = true; SUDAH DIHAPUS.
                  // Status meja akan berubah nanti setelah pembayaran selesai.

                  Navigator.pushNamed(
                    context,
                    '/payment_summary',
                    arguments: {
                      'isQueue': isQueue,
                      'table': table,
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
