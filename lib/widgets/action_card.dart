// lib/widgets/action_card.dart
import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final IconData icon; // Gambarnya apa?
  final String title; // Judulnya apa?
  final String subtitle; // Keterangannya apa?
  final VoidCallback onTap; // Kalo diklik mau ke mana?

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF5D4037); // Warna coklat
    const Color cardBgColor = Color(0xFFF7F4EF); // Warna krem

    return InkWell(
      onTap: onTap, // Fungsi kliknya
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white, // Kartunya warna putih
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.1,
              ), // Kasih bayangan tipis biar cantik
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Kotak kecil buat tempat Ikon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 30, color: primaryColor),
            ),
            const SizedBox(width: 20),
            // Bagian teks (Judul & Subjudul)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
