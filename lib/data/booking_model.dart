// lib/data/booking_model.dart
class BookingModel {
  final String id;
  final String tableNumber;
  final String qrCodeData;
  final String guestName;
  final DateTime date;
  final String startTime;
  final String endTime;
  final double totalAmount;
  String status;

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

  // MENGUBAH DATA MENJADI TEXT (JSON) - Untuk Disimpan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'guestName': guestName,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'totalAmount': totalAmount,
      'status': status,
      'qrCodeData': qrCodeData,
    };
  }

  // MENGUBAH TEXT (JSON) MENJADI DATA - Untuk Dimuat
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      tableNumber: json['tableNumber'],
      guestName: json['guestName'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      qrCodeData: json['qrCodeData'],
    );
  }
}
