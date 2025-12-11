// lib/data/booking_queue.dart
import 'booking_model.dart';
import 'queue_node.dart';

class BookingQueue {
  QueueNode? head;
  QueueNode? tail;
  int size = 0;

  void enqueue(BookingModel data) {
    QueueNode newNode = QueueNode(data);

    if (head == null) {
      head = newNode;
      tail = newNode;
    } else {
      tail!.next = newNode;
      tail = newNode;
    }
    size++;
  }

  BookingModel? dequeue() {
    if (head == null) {
      return null;
    }

    BookingModel removedData = head!.data;
    head = head!.next;
    size--;

    if (head == null) {
      tail = null;
    }

    return removedData;
  }

  bool get isEmpty => head == null;

  List<BookingModel> toList() {
    List<BookingModel> bookings = [];
    QueueNode? current = head;
    while (current != null) {
      bookings.add(current.data);
      current = current.next;
    }
    return bookings;
  }
}
