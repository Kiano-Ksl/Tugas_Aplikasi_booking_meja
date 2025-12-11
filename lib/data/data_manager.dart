// lib/data/data_manager.dart
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

  // FIX: Semua meja di-set isOccupied: false (Hijau)
  static final List<Table> cafeTables = [
    Table('T1', 2, isOccupied: false),
    Table('T2', 4, isOccupied: false),
    Table('T3', 2, isOccupied: false),
    Table('T4', 4, isOccupied: false),
    Table('T5', 6, isOccupied: false),
    Table('T6', 2, isOccupied: false),
  ];

  // FIX: Kosongkan daftar booking awal agar "My Bookings" bersih
  static List<BookingModel> userBookings = [];

  // --- LOGIKA BARU: MENANGANI PENYELESAIAN ORDER (CHAIN REACTION) ---
  static void completeBooking(BookingModel booking) {
    // 1. Tandai booking saat ini sebagai 'Completed'
    booking.status = 'Completed';

    // 2. Cari antrian berikutnya untuk MEJA YANG SAMA (Prinsip FIFO)
    // Kita mencari booking pertama yang statusnya 'Queueing' untuk nomor meja ini
    try {
      BookingModel nextInLine = userBookings.firstWhere(
        (b) => b.tableNumber == booking.tableNumber && b.status == 'Queueing',
      );

      // Jika ada yang antri, ubah statusnya jadi 'Confirmed'
      nextInLine.status = 'Confirmed';
      // Meja tetap merah (isOccupied = true) karena ada penggantinya
    } catch (e) {
      // Jika TIDAK ada yang antri (catch error firstWhere), meja jadi kosong lagi
      Table table = cafeTables.firstWhere(
        (t) => t.number == booking.tableNumber,
      );
      table.isOccupied = false; // Meja jadi Hijau
    }
  }
}
