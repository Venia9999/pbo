import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movie.dart';
import '../models/ticket_data.dart';
import '../data/ticket_storage.dart';
import '../providers/user_provider.dart';

class TicketPage extends StatefulWidget {
  final Movie movie;
  const TicketPage({super.key, required this.movie});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  int jumlahTiket = 1;
  String jamDipilih = "13:00";
  String? kursiDipilih;

  String metodePembayaran = "BCA";

  static const int hargaTiket = 40000;
  int get totalHarga => hargaTiket * jumlahTiket;

  final List<String> jamTayang = [
    "10:00", "13:00", "16:00", "19:00", "21:00"
  ];

  final List<String> kursi = [
    "A1","A2","A3","A4",
    "B1","B2","B3","B4",
    "C1","C2","C3","C4",
  ];

  final List<String> bankList = [
    "BCA", "BNI", "BRI", "MANDIRI"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesan Tiket"),
        backgroundColor: const Color(0xFF0A1F44),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoFilm(),
            const SizedBox(height: 20),
            _pilihJam(),
            const SizedBox(height: 20),
            _pilihJumlah(),
            const SizedBox(height: 16),
            _infoHarga(),
            const SizedBox(height: 20),
            _pilihKursi(),
            const SizedBox(height: 20),
            _pilihPembayaran(),
            const SizedBox(height: 30),
            _tombolPesan(),
          ],
        ),
      ),
    );
  }

  // ================= INFO FILM =================
  Widget _infoFilm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Row(
        children: [
          Image.network(widget.movie.poster, width: 90),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("${widget.movie.duration} menit"),
            ],
          ),
        ],
      ),
    );
  }

  // ================= JAM =================
  Widget _pilihJam() {
    return Wrap(
      spacing: 10,
      children: jamTayang.map((jam) {
        return ChoiceChip(
          label: Text(jam),
          selected: jam == jamDipilih,
          selectedColor: const Color(0xFF0A1F44),
          labelStyle: TextStyle(
            color: jam == jamDipilih ? Colors.white : Colors.black,
          ),
          onSelected: (_) => setState(() => jamDipilih = jam),
        );
      }).toList(),
    );
  }

  // ================= JUMLAH =================
  Widget _pilihJumlah() {
    return Container(
      decoration: _box(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed:
                jumlahTiket > 1 ? () => setState(() => jumlahTiket--) : null,
          ),
          Text(
            jumlahTiket.toString(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => jumlahTiket++),
          ),
        ],
      ),
    );
  }

  // ================= HARGA =================
  Widget _infoHarga() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Harga",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "Rp $totalHarga",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A1F44),
            ),
          ),
        ],
      ),
    );
  }

  // ================= KURSI =================
  Widget _pilihKursi() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kursi.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final seat = kursi[i];
        final selected = seat == kursiDipilih;

        return GestureDetector(
          onTap: () => setState(() => kursiDipilih = seat),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0A1F44) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              seat,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= PEMBAYARAN =================
  Widget _pilihPembayaran() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Metode Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: bankList.map((bank) {
            return ChoiceChip(
              label: Text(bank),
              selected: metodePembayaran == bank,
              selectedColor: const Color(0xFF0A1F44),
              labelStyle: TextStyle(
                color:
                    metodePembayaran == bank ? Colors.white : Colors.black,
              ),
              onSelected: (_) =>
                  setState(() => metodePembayaran = bank),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ================= TOMBOL PESAN =================
  Widget _tombolPesan() {
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
          if (kursiDipilih == null) return;

          final user =
              Provider.of<UserProvider>(context, listen: false).user;
          if (user == null) return;

          final va = _generateVA(metodePembayaran);
          final expired =
              DateTime.now().add(const Duration(minutes: 30));

          TicketStorage.tickets.add(
            TicketData(
              namaUser: user.name,
              movieTitle: widget.movie.title,
              jam: jamDipilih,
              kursi: kursiDipilih!,
              tanggal: DateTime.now(),
              jumlahTiket: jumlahTiket,
              totalHarga: totalHarga,
              metodePembayaran: metodePembayaran,
              virtualAccount: va,
              expiredAt: expired,
              status: PaymentStatus.pending,
            ),
          );

          Navigator.pop(context);
        },
        child: const Text(
          "Pesan Sekarang",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // ================= UTIL =================
  String _generateVA(String bank) {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    return "${bank.substring(0, 3)}-${time.substring(time.length - 10)}";
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
        ),
      ],
    );
  }
}
