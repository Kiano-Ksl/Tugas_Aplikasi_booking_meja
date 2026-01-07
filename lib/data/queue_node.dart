// lib/data/queue_node.dart
import 'booking_model.dart';

class QueueNode {
  BookingModel data; // Isinya data pesanan
  QueueNode? next; // Tangan yang ngegandeng gerbong di belakangnya

  QueueNode(this.data); // Pas gerbong dibuat, langsung diisi datanya
}
