// lib/data/booking_queue.dart
import 'booking_model.dart';
import 'queue_node.dart';

class BookingQueue {
  QueueNode? head; // Lokomotif (orang pertama di antrian)
  QueueNode? tail; // Gerbong paling belakang (orang terakhir)
  int size = 0; // Itungan ada berapa orang di barisan

  // Fungsi Masuk Antrian (Daftar di paling belakang)
  void enqueue(BookingModel data) {
    QueueNode newNode = QueueNode(data); // Bikin gerbong baru

    if (head == null) {
      // Kalau barisan kosong, dia jadi yang pertama sekaligus terakhir
      head = newNode;
      tail = newNode;
    } else {
      // Kalau udah ada orang, dia gandeng tangan orang paling belakang (tail)
      tail!.next = newNode;
      tail = newNode; // Sekarang dia yang jadi orang paling belakang
    }
    size++; // Barisan nambah satu orang
  }

  // Fungsi Panggil Antrian (Orang paling depan keluar barisan)
  BookingModel? dequeue() {
    if (head == null) {
      return null; // Kalau gak ada orang, ya gak ada yang dipanggil
    }

    BookingModel removedData = head!.data; // Ambil data orang paling depan
    head = head!.next; // Geser, orang kedua sekarang jadi orang pertama
    size--; // Barisan berkurang satu orang

    if (head == null) {
      tail = null; // Kalau setelah geser jadi kosong, ekornya juga ilang
    }

    return removedData; // Balikin data orang yang dipanggil tadi
  }

  // Cek antrian kosong atau gak
  bool get isEmpty => head == null;

  // Ngubah antrian (Linked List) jadi List biasa biar gampang ditampilin di layar
  List<BookingModel> toList() {
    List<BookingModel> bookings = [];
    QueueNode? current = head; // Mulai ngecek dari paling depan
    while (current != null) {
      bookings.add(current.data); // Masukin data ke list
      current = current.next; // Geser ke gerbong di belakangnya
    }
    return bookings;
  }
}
