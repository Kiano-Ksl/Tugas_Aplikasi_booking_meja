// lib/data/queue_node.dart
import 'booking_model.dart';

class QueueNode {
  BookingModel data;
  QueueNode? next;

  QueueNode(this.data);
}
