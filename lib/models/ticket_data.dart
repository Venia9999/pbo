class TicketData {
  final String namaUser;
  final String movieTitle;
  final String jam;
  final String kursi;
  final DateTime tanggal;
  final int jumlahTiket;
  final int totalHarga;
  final String metodePembayaran;
  final String virtualAccount;
  final DateTime expiredAt;
  final PaymentStatus status;

  TicketData({
    required this.namaUser,
    required this.movieTitle,
    required this.jam,
    required this.kursi,
    required this.tanggal,
    required this.jumlahTiket,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.virtualAccount,
    required this.expiredAt,
    required this.status,
  });
}

enum PaymentStatus {
  pending,
  paid,
  expired,
}
