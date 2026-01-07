// lib/screens/booking_form_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm; // Panggil data manager
import '../data/booking_model.dart'; // Panggil model booking

class BookingFormScreen extends StatefulWidget {
  const BookingFormScreen({super.key});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  // Pengendali teks buat ngambil inputan nama & HP
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variabel buat nampung tanggal & jam yang dipilih
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  // --- ATURAN MAIN (KONFIGURASI) ---
  final int _minNameLength = 3; // Nama minimal 3 huruf
  final int _minPhoneLength = 10; // HP minimal 10 angka
  final int _minDurationMinutes = 60; // Minimal sewa 1 jam
  final int _maxDurationMinutes = 180; // Maksimal sewa 3 jam

  // Bersihin memori kalau halaman ditutup
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- FUNGSI BIKIN INPUTAN BIAR RAPI ---
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false, // Kalau true, keyboardnya angka doang
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        // Trik biar keyboard HP muncul angka langsung
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
          border: const OutlineInputBorder(), // Garis kotak biasa
        ),
      ),
    );
  }

  // --- FUNGSI PILIH TANGGAL (Kalender) ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Mulai dari hari ini
      firstDate: DateTime.now(), // Gak boleh pilih masa lalu
      lastDate: DateTime(DateTime.now().year + 1), // Maksimal setahun ke depan
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- FUNGSI PILIH JAM (Jam Mulai / Selesai) ---
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

  // Helper: Ubah jam (misal 01:30) jadi menit total (90 menit) biar gampang dihitung
  int _toMinutes(TimeOfDay time) {
    return (time.hour * 60) + time.minute;
  }

  // --- LOGIKA DETEKSI TABRAKAN JADWAL (PENTING!) ---
  bool _isTimeSlotAvailable(
    String tableNumber,
    DateTime date,
    TimeOfDay start,
    TimeOfDay end,
  ) {
    int newStart = _toMinutes(start);
    int newEnd = _toMinutes(end);

    // Cek satu-satu semua booking yang ada di database
    for (var existingBooking in dm.DataManager.userBookings) {
      // 1. Kalau mejanya beda, ya aman, lanjut cek yang lain
      if (existingBooking.tableNumber != tableNumber) continue;

      // 2. Kalau tanggalnya beda, aman juga
      bool isSameDay =
          existingBooking.date.year == date.year &&
          existingBooking.date.month == date.month &&
          existingBooking.date.day == date.day;

      if (!isSameDay) continue;

      // 3. Kalau statusnya udah Batal atau Selesai, kita anggap slotnya kosong
      if (existingBooking.status == 'Cancelled' ||
          existingBooking.status == 'Completed')
        continue;

      // --- CEK JAMNYA ---
      // Kita ambil jam mulai & selesai dari data lama
      TimeOfDay existingStartObj = _parseTime(existingBooking.startTime);
      TimeOfDay existingEndObj = _parseTime(existingBooking.endTime);

      int existingStart = _toMinutes(existingStartObj);
      int existingEnd = _toMinutes(existingEndObj);

      // RUMUS MATEMATIKA TABRAKAN WAKTU:
      // (MulaiBaru < SelesaiLama) DAN (SelesaiBaru > MulaiLama)
      // Kalau ini True, berarti nabrak!
      if (newStart < existingEnd && newEnd > existingStart) {
        return false; // Yah, bentrok nih!
      }
    }

    return true; // Aman, slot tersedia
  }

  // Fungsi darurat buat baca jam dari teks database
  TimeOfDay _parseTime(String timeString) {
    try {
      // Bersihin teks dari huruf aneh-aneh, ambil angkanya aja
      final cleanString = timeString.replaceAll(RegExp(r'[a-zA-Z\s]'), '');
      final parts = cleanString.split(":");

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Kalau ada PM, tambah 12 jam (biar jadi format 24 jam)
      if (timeString.toUpperCase().contains("PM") && hour < 12) {
        hour += 12;
      }
      if (timeString.toUpperCase().contains("AM") && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return TimeOfDay.now(); // Kalau error, balikin jam sekarang aja
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tangkap data meja yang dikirim dari halaman sebelumnya
    final table = ModalRoute.of(context)?.settings.arguments as dm.Table?;
    // Cek apakah meja ini lagi merah (penuh)?
    final isQueue = table?.isOccupied ?? false;

    return Scaffold(
      appBar: AppBar(title: Text('Booking Meja ${table?.number ?? ''}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Status di Atas
            Text(
              isQueue
                  ? 'Meja ini sedang PENUH. Kamu akan masuk ANTRIAN.' // Pesan merah
                  : 'Meja ini KOSONG. Silakan isi data reservasi.', // Pesan hijau
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isQueue ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Input Nama & HP
            _buildInputField(
              label: 'Nama Pemesan',
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            _buildInputField(
              label: 'Nomor HP (WhatsApp)',
              controller: _phoneController,
              icon: Icons.phone,
              isNumber: true, // Keyboard angka
            ),

            // Pilihan Tanggal
            _buildTimePickerTile(
              label: 'Tanggal Booking',
              icon: Icons.calendar_today,
              value: _selectedDate == null
                  ? 'Pilih Tanggal'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              onTap: () => _selectDate(context),
            ),

            // Pilihan Jam Mulai
            _buildTimePickerTile(
              label: 'Jam Mulai',
              icon: Icons.access_time,
              value: _selectedStartTime?.format(context) ?? 'Pilih Jam',
              onTap: () => _selectTime(context, true),
            ),
            // Pilihan Jam Selesai
            _buildTimePickerTile(
              label: 'Jam Selesai',
              icon: Icons.access_time_filled,
              value: _selectedEndTime?.format(context) ?? 'Pilih Jam',
              onTap: () => _selectTime(context, false),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL LANJUT PEMBAYARAN ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // --- 1. CEK KELENGKAPAN DATA ---
                  if (_nameController.text.length < _minNameLength) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Nama minimal $_minNameLength huruf ya!"),
                      ),
                    );
                    return;
                  }
                  if (_phoneController.text.length < _minPhoneLength) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Nomor HP minimal $_minPhoneLength angka!",
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
                        content: Text("Jangan lupa isi tanggal dan jamnya!"),
                      ),
                    );
                    return;
                  }

                  // --- 2. CEK VALIDITAS WAKTU (MASA LALU) ---
                  // Kita ambil waktu sekarang
                  final now = DateTime.now();
                  // Cek apakah tanggal yang dipilih adalah HARI INI?
                  final isToday =
                      _selectedDate!.year == now.year &&
                      _selectedDate!.month == now.month &&
                      _selectedDate!.day == now.day;

                  if (isToday) {
                    // Ubah jam sekarang jadi menit (misal 14:00 -> 840 menit)
                    final currentMinutes = now.hour * 60 + now.minute;
                    // Ubah jam yang dipilih jadi menit
                    final selectedStartMinutes = _toMinutes(
                      _selectedStartTime!,
                    );

                    // Kalau jam yang dipilih LEBIH KECIL dari jam sekarang -> TOLAK
                    if (selectedStartMinutes < currentMinutes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Jam sudah lewat! Pilih waktu yang akan datang.",
                          ),
                        ),
                      );
                      return;
                    }
                  }

                  // --- 3. CEK DURASI SEWA ---
                  int startMin = _toMinutes(_selectedStartTime!);
                  int endMin = _toMinutes(_selectedEndTime!);
                  int duration = endMin - startMin;

                  if (endMin <= startMin) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Jam selesai harus setelah jam mulai dong!",
                        ),
                      ),
                    );
                    return;
                  }

                  if (duration < _minDurationMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Booking minimal harus 1 jam."),
                      ),
                    );
                    return;
                  }

                  if (duration > _maxDurationMinutes) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Booking maksimal cuma boleh 3 jam."),
                      ),
                    );
                    return;
                  }

                  // --- 4. CEK BENTROK JADWAL ---
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
                            "Waduh, jam segitu mejanya udah ada yang booking! Cari jam lain ya.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // STOP! Jangan lanjut
                    }
                  }

                  // Kalau semua aman, baru pindah ke halaman bayar
                  Navigator.pushNamed(
                    context,
                    '/payment_summary',
                    arguments: {
                      'isQueue': isQueue, // Kirim info: ini antrian atau bukan?
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
                child: Text(isQueue ? 'Masuk Antrian' : 'Lanjut Pembayaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget bantuan buat kotak pilih jam/tanggal
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
