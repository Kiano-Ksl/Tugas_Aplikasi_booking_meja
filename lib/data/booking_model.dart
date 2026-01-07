// lib/data/booking_model.dart
class BookingModel {
  // Ini semua variabel buat nyimpen info satu pesanan
  final String id;
  final String tableNumber;
  final String qrCodeData;
  final String guestName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double totalAmount;
  String status;

  // Constructor: Buat ngerakit datanya pas baru dipesan
  BookingModel({
    required this.id,
    required this.tableNumber,
    required this.guestName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    required this.qrCodeData,
  });

  // FUNGSI SAKTI 1: Ngubah objek data jadi teks (JSON) biar bisa disimpan di HP
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'guestName': guestName,
      'date': date.toIso8601String(), // Tanggal dibikin jadi teks standar
      'startTime': startTime,
      'endTime': endTime,
      'totalAmount': totalAmount,
      'status': status,
      'qrCodeData': qrCodeData,
    };
  }

  // FUNGSI SAKTI 2: Ngambil teks (JSON) dari HP terus dibalikin lagi jadi objek data
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      tableNumber: json['tableNumber'],
      guestName: json['guestName'],
      date: DateTime.parse(json['date']), // Teks dibalikin jadi format tanggal
      startTime: json['startTime'],
      endTime: json['endTime'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      qrCodeData: json['qrCodeData'],
    );
  }
}
