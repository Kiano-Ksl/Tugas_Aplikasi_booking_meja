// lib/screens/choose_table_screen.dart
import 'package:flutter/material.dart';
import '../data/data_manager.dart' as dm; // <-- FIX: Menggunakan prefix 'dm'

class ChooseTableScreen extends StatefulWidget {
  final bool isBooking;
  const ChooseTableScreen({super.key, required this.isBooking});

  @override
  State<ChooseTableScreen> createState() => _ChooseTableScreenState();
}

class _ChooseTableScreenState extends State<ChooseTableScreen> {
  // FIX: Menggunakan dm.Table
  Widget _buildTableItem(BuildContext context, dm.Table table) {
    Color statusColor = table.isOccupied
        ? Colors.red.shade700
        : Colors.green.shade700;

    void handleTap() {
      if (!widget.isBooking) return;

      if (table.isOccupied) {
        _showQueueDialog(context, table);
      } else {
        Navigator.pushNamed(context, '/booking_form', arguments: table);
      }
    }

    return InkWell(
      onTap: handleTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chair, size: 40, color: statusColor),
            const SizedBox(height: 10),
            Text(
              'Table ${table.number}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Capacity: ${table.capacity}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              table.isOccupied
                  ? 'Occupied (Queue: ${dm.DataManager.bookingQueue.size})'
                  : 'Available',
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX: Menggunakan dm.Table
  void _showQueueDialog(BuildContext context, dm.Table table) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Table ${table.number} is Occupied'),
          content: const Text('Do you want to join the queue for this table?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/booking_form', arguments: table);
              },
              child: const Text('Join Queue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.isBooking ? 'Book a Table' : 'View Queue Status';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isBooking
                  ? 'Select an available (green) table to book, or join the queue (red table).'
                  : 'Monitor table availability and queue length.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: dm
                    .DataManager
                    .cafeTables
                    .length, // FIX: Menggunakan dm.DataManager
                itemBuilder: (context, index) {
                  return _buildTableItem(
                    context,
                    dm.DataManager.cafeTables[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
