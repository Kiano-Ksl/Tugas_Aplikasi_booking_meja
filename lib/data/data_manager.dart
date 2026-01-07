// lib/data/data_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_queue.dart';
import 'booking_model.dart';

class Table {
  final String number;
  final int capacity;
  bool isOccupied;

  Table(this.number, this.capacity, {this.isOccupied = false});
}

class DataManager {
  static final BookingQueue bookingQueue = BookingQueue();

  static final List<Table> cafeTables = [
    Table('T1', 2, isOccupied: false),
    Table('T2', 4, isOccupied: false),
    Table('T3', 2, isOccupied: false),
    Table('T4', 4, isOccupied: false),
    Table('T5', 6, isOccupied: false),
    Table('T6', 2, isOccupied: false),
  ];

  static List<BookingModel> userBookings = [];

  // --- 1. FUNGSI MENYIMPAN DATA (SAVE) ---
  static Future<void> saveBookings() async {
    final prefs = await SharedPreferences.getInstance();

    // Ubah data jadi JSON
    final String encodedData = jsonEncode(
      userBookings.map((booking) => booking.toJson()).toList(),
    );

    // Simpan ke memori HP
    await prefs.setString('saved_bookings', encodedData);

    // --- PERBAIKAN DI SINI ---
    // Update warna meja segera setelah data disimpan!
    _updateTableStatus();

    print("Data berhasil disimpan dan status meja diperbarui!");
  }

  // --- 2. FUNGSI MEMUAT DATA (LOAD) ---
  static Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('saved_bookings');

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      userBookings = decodedData
          .map((item) => BookingModel.fromJson(item))
          .toList();

      // Update warna meja saat aplikasi baru dibuka
      _updateTableStatus();
    }
  }

  // Helper: Cek semua booking, kalau ada yang aktif, bikin meja jadi Merah
  static void _updateTableStatus() {
    // 1. Reset semua meja jadi Hijau dulu
    for (var table in cafeTables) {
      table.isOccupied = false;
    }

    // 2. Cek booking satu per satu
    for (var booking in userBookings) {
      // Jika statusnya Confirmed atau Queueing, berarti meja sedang dipakai
      if (booking.status == 'Confirmed' || booking.status == 'Queueing') {
        // Cari meja yang sesuai nomornya
        try {
          var table = cafeTables.firstWhere(
            (t) => t.number == booking.tableNumber,
          );
          table.isOccupied = true; // Ubah jadi Merah
        } catch (e) {
          print(
            "Error: Meja ${booking.tableNumber} tidak ditemukan di cafeTables",
          );
        }
      }
    }
  }

  // Logika Complete Booking
  static void completeBooking(BookingModel booking) {
    booking.status = 'Completed';

    // Cek apakah ada antrian untuk meja ini?
    try {
      BookingModel nextInLine = userBookings.firstWhere(
        (b) => b.tableNumber == booking.tableNumber && b.status == 'Queueing',
      );

      // Kalau ada, status dia naik jadi Confirmed (Meja tetap Merah)
      nextInLine.status = 'Confirmed';
    } catch (e) {
      // Kalau tidak ada antrian, meja jadi Hijau (logika ini akan di-override oleh _updateTableStatus saat save, tapi tidak masalah)
      try {
        Table table = cafeTables.firstWhere(
          (t) => t.number == booking.tableNumber,
        );
        table.isOccupied = false;
      } catch (e) {}
    }

    // SIMPAN PERUBAHAN (Otomatis update warna meja juga)
    saveBookings();
  }
}
