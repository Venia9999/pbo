import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final String movieTitle;
  final String jam;
  final String kursi;
  final DateTime tanggal;
  final int jumlahTiket;
  final int totalHarga;

  const HistoryPage({
    super.key,
    required this.movieTitle,
    required this.jam,
    required this.kursi,
    required this.tanggal,
    required this.jumlahTiket,
    required this.totalHarga,
  });

  String get kodePembelian {
    return "BKP-${tanggal.year}${tanggal.month}${tanggal.day}-${tanggal.millisecondsSinceEpoch.toString().substring(8)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Detail Tiket"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A1F44),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ticketCard(),
            const SizedBox(height: 24),
            _infoLoket(),
            const Spacer(),
            _btnKembaliHome(context),
          ],
        ),
      ),
    );
  }

  // ================= KARTU TIKET =================
  Widget _ticketCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rowInfo("Film", movieTitle),
          _divider(),
          _rowInfo("Jam Tayang", jam),
          _rowInfo("Kursi", kursi),
          _rowInfo("Jumlah Tiket", "$jumlahTiket"),
          _rowInfo(
            "Tanggal",
            "${tanggal.day}-${tanggal.month}-${tanggal.year}",
          ),
          _divider(),
          _rowInfo(
            "Total Harga",
            "Rp ${totalHarga.toString()}",
          ),
          const SizedBox(height: 20),

          // KODE PEMBELIAN
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F44),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kode Pembelian",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  kodePembelian,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= INFO LOKET =================
  Widget _infoLoket() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFF0A1F44)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Tunjukkan kode pembelian ini ke loket bioskop untuk mencetak tiket.",
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON =================
  Widget _btnKembaliHome(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A1F44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: const Text(
          "Kembali ke Home",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // ================= UTIL =================
  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Colors.grey.shade300),
    );
  }
}
