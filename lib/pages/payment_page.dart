import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ticket_data.dart';
import '../providers/ticket_provider.dart';
import 'history_page.dart';

class PaymentPage extends StatefulWidget {
  final TicketData ticket;

  const PaymentPage({super.key, required this.ticket});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  static const Color gold = Color(0xFFD4AF37);
  String metodePembayaran = "BCA";
  File? buktiPembayaran;

  final List<String> bankList = ["BCA", "BNI", "BRI", "MANDIRI"];
  final Map<String, String> bankRekening = {
    "BCA": "123-456-7890 a.n. Bioskop App",
    "BNI": "987-654-3210 a.n. Bioskop App",
    "BRI": "111-222-3333 a.n. Bioskop App",
    "MANDIRI": "444-555-6666 a.n. Bioskop App",
  };

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    metodePembayaran = widget.ticket.metodePembayaran;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        buktiPembayaran = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Tiket"),
        backgroundColor: Colors.white,
        foregroundColor: gold,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Tiket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _ticketDetailCard(),
            const SizedBox(height: 20),
            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _bankSelection(),
            const SizedBox(height: 16),
            _bankDetailCard(),
            const SizedBox(height: 16),
            const Text(
              "Upload Bukti Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _uploadBuktiButton(),
            const SizedBox(height: 16),
            _noteCard(),
            const SizedBox(height: 24),
            _btnBayar(),
          ],
        ),
      ),
    );
  }

  Widget _ticketDetailCard() {
    final t = widget.ticket;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(4),
        },
        children: [
          _tableRow("Film", t.movieTitle),
          _tableRow("Jam Tayang", t.jam),
          _tableRow("Kursi", t.kursi),
          _tableRow("Jumlah Tiket", "${t.jumlahTiket}"),
          _tableRow("Total Harga", "Rp ${t.totalHarga}", isHighlight: true),
        ],
      ),
    );
  }

  TableRow _tableRow(String label, String value, {bool isHighlight = false}) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
            color: isHighlight ? gold : Colors.black87,
          ),
        ),
      ),
    ]);
  }

  Widget _bankSelection() {
    return Wrap(
      spacing: 10,
      children: bankList.map((bank) {
        final selected = metodePembayaran == bank;
        return ChoiceChip(
          label: Text(bank),
          selected: selected,
          selectedColor: gold,
          labelStyle: TextStyle(
            color: selected ? Colors.white : gold,
            fontWeight: FontWeight.bold,
          ),
          onSelected: (_) {
            setState(() => metodePembayaran = bank);
          },
        );
      }).toList(),
    );
  }

  Widget _bankDetailCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance, color: gold),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Transfer ke rekening $metodePembayaran: ${bankRekening[metodePembayaran]}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadBuktiButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: gold),
        ),
        child: buktiPembayaran != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(buktiPembayaran!, fit: BoxFit.cover),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload, size: 40, color: gold),
                    SizedBox(height: 8),
                    Text(
                      "Klik untuk upload bukti pembayaran",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _noteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "Catatan: Pastikan bukti pembayaran sesuai dan sah. "
        "Tunjukkan bukti ini ke loket bioskop untuk mencetak tiket.",
        style: TextStyle(fontSize: 13, color: Colors.black87),
      ),
    );
  }

  Widget _btnBayar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: buktiPembayaran == null
            ? null
            : () {
                final ticketProvider =
                    Provider.of<TicketProvider>(context, listen: false);

                widget.ticket.metodePembayaran = metodePembayaran;
                ticketProvider.addTicket(widget.ticket);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pembayaran berhasil!"),
                  ),
                );

                // ✅ LANGSUNG KE DETAIL TIKET
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HistoryPage(ticket: widget.ticket),
                  ),
                );
              },
        child: const Text(
          "Bayar Sekarang",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
