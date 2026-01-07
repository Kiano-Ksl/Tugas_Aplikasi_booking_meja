// lib/data/data_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Paket buat simpan data di HP
import 'booking_queue.dart';
import 'booking_model.dart';

// Cetakan buat data Meja
class Table {
  final String number;
  final int capacity;
  bool isOccupied; // Status: Lagi dipake atau kosong?

  Table(this.number, this.capacity, {this.isOccupied = false});
}

class DataManager {
  // Panggil sistem antrian kita tadi
  static final BookingQueue bookingQueue = BookingQueue();

  // Daftar meja yang ada di kafe kita
  static final List<Table> cafeTables = [
    Table('T1', 2),
    Table('T2', 4),
    Table('T3', 2),
    Table('T4', 4),
    Table('T5', 6),
    Table('T6', 2),
  ];

  // List buat nampung semua pesanan user
  static List<BookingModel> userBookings = [];

  // FUNGSI 1: SIMPAN DATA KE HP (Biar gak ilang pas aplikasi ditutup)
  static Future<void> saveBookings() async {
    final prefs = await SharedPreferences.getInstance();

    // Ngubah semua daftar pesanan jadi teks (JSON)
    final String encodedData = jsonEncode(
      userBookings.map((booking) => booking.toJson()).toList(),
    );

    // Titip simpan teks tadi di memori HP
    await prefs.setString('saved_bookings', encodedData);

    // Langsung update warna meja biar sinkron
    _updateTableStatus();

    print("Data aman tersimpan di HP!");
  }

  // FUNGSI 2: AMBIL DATA DARI HP (Pas aplikasi baru dibuka)
  static Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(
      'saved_bookings',
    ); // Ambil teksnya

    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      // Ubah balik teks jadi daftar pesanan asli
      userBookings = decodedData
          .map((item) => BookingModel.fromJson(item))
          .toList();

      // Update warna meja biar gak ijo semua
      _updateTableStatus();
    }
  }

  // FUNGSI 3: UPDATE WARNA MEJA (Hijau/Merah)
  static void _updateTableStatus() {
    // Reset dulu semua meja jadi ijo (kosong)
    for (var table in cafeTables) {
      table.isOccupied = false;
    }

    // Cek satu-satu pesanan user
    for (var booking in userBookings) {
      // Kalau ada pesanan yang 'Confirmed' atau lagi 'Antri', mejanya jadi Merah
      if (booking.status == 'Confirmed' || booking.status == 'Queueing') {
        try {
          var table = cafeTables.firstWhere(
            (t) => t.number == booking.tableNumber,
          );
          table.isOccupied = true; // MEJA JADI MERAH
        } catch (e) {
          print("Meja gak ketemu!");
        }
      }
    }
  }

  // FUNGSI 4: SELESAIKAN PESANAN
  static void completeBooking(BookingModel booking) {
    booking.status = 'Completed'; // Ganti status jadi Selesai

    // Cek, ada gak orang yang lagi antri di meja ini?
    try {
      BookingModel nextInLine = userBookings.firstWhere(
        (b) => b.tableNumber == booking.tableNumber && b.status == 'Queueing',
      );

      // Kalau ada, status dia naik jadi Confirmed (Gantian dia yang makan)
      nextInLine.status = 'Confirmed';
    } catch (e) {
      // Kalau gak ada yang antri, meja balik jadi ijo
      try {
        Table table = cafeTables.firstWhere(
          (t) => t.number == booking.tableNumber,
        );
        table.isOccupied = false;
      } catch (e) {}
    }

    // Save setiap ada perubahan biar permanen
    saveBookings();
  }
}
