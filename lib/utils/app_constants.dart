// ============================================================
// BAGIAN 3: KONSTANTA APLIKASI
// File: lib/utils/app_constants.dart
//
// Konsep: static const List - data tetap yang dipakai di mana-mana
// ============================================================

class AppConstants {
  // Daftar kategori wisata yang tersedia di seluruh aplikasi
  static const List<String> kategoriList = [
    'Pantai',
    'Alam',
    'Danau',
    'Pulau',
    'Budaya',
    'Sejarah',
    'Kuliner',
    'Lainnya',
  ];

  // Pesan default WhatsApp
  static const String whatsappMessage =
      'Halo, saya tertarik dengan informasi wisata ini. Bisa bantu saya?';
}
