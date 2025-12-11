import 'booking_model.dart';

class QueueNode {
  BookingModel data;
  QueueNode? next;

  QueueNode(this.data);
}
