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
}
