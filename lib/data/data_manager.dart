// lib/data/data_manager.dart
import 'booking_queue.dart';
import 'booking_model.dart'; // Import ini penting agar BookingModel dikenali

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
    Table('T2', 4, isOccupied: true),
    Table('T3', 2, isOccupied: false),
    Table('T4', 4, isOccupied: true),
    Table('T5', 6, isOccupied: false),
    Table('T6', 2, isOccupied: false),
  ];

  // FIX: Pastikan ini static dan menggunakan BookingModel
  static List<BookingModel> userBookings = [
    BookingModel(
      id: 'B001',
      tableNumber: 'T3',
      guestName: 'Budi Santoso',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: '14:00',
      endTime: '16:00',
      totalAmount: 50.00,
      status: 'Confirmed',
      qrCodeData: 'https://qrcode.me/B001',
    ),
    BookingModel(
      id: 'B002',
      tableNumber: 'T2',
      guestName: 'Ani Wijaya',
      date: DateTime.now().subtract(const Duration(days: 2)),
      startTime: '10:00',
      endTime: '11:30',
      totalAmount: 0.00,
      status: 'Completed',
      qrCodeData: 'https://qrcode.me/B002',
    ),
  ];
}
