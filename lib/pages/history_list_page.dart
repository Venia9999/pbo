import 'package:flutter/material.dart';
import '../data/ticket_storage.dart';
import '../models/ticket_data.dart';
import 'history_page.dart';

class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TicketData> tickets = TicketStorage.tickets;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Riwayat Tiket"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A1F44),
        foregroundColor: Colors.white,
      ),

      body: tickets.isEmpty
          ? const Center(
              child: Text(
                "Belum ada tiket",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];

                return _historyItem(
                  context,
                  ticket: ticket,
                );
              },
            ),
    );
  }

  Widget _historyItem(
    BuildContext context, {
    required TicketData ticket,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryPage(
              movieTitle: ticket.movieTitle,
              jam: ticket.jam,
              kursi: ticket.kursi,
              tanggal: ticket.tanggal,
              jumlahTiket: ticket.jumlahTiket,
              totalHarga: ticket.totalHarga,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.movieTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Jam ${ticket.jam} • Kursi ${ticket.kursi}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              "Jumlah: ${ticket.jumlahTiket} tiket",
            ),
            const SizedBox(height: 4),
            Text(
              "Total: Rp ${ticket.totalHarga}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1F44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
