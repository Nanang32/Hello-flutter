// ============================================================
// BAGIAN 1: MODEL DATA
// File: lib/models/wisata_model.dart
//
// Konsep yang dipelajari:
// - Dart Class dengan constructor
// - Named parameters & optional parameters
// - Method copyWith (immutable update pattern)
// ============================================================

class WisataModel {
  final int id;
  final String nama;
  final String daerah;
  final String provinsi;
  final String deskripsi;
  final String kategori;
  final String noHp;
  final String namaKontak;
  final double latitude;
  final double longitude;
  final String? gambarUrl;   // nullable: boleh kosong
  final double rating;
  final String jamBuka;
  final String hargaTiket;
  final DateTime createdAt;

  // Constructor: semua field wajib kecuali yang pakai '?' atau punya default
  const WisataModel({
    required this.id,
    required this.nama,
    required this.daerah,
    required this.provinsi,
    required this.deskripsi,
    required this.kategori,
    required this.noHp,
    required this.namaKontak,
    required this.latitude,
    required this.longitude,
    this.gambarUrl,
    this.rating = 0.0,
    required this.jamBuka,
    required this.hargaTiket,
    required this.createdAt,
  });

  // copyWith: buat salinan objek dengan beberapa field diubah
  // Berguna karena kita tidak bisa ubah field langsung (final)
  WisataModel copyWith({
    int? id,
    String? nama,
    String? daerah,
    String? provinsi,
    String? deskripsi,
    String? kategori,
    String? noHp,
    String? namaKontak,
    double? latitude,
    double? longitude,
    String? gambarUrl,
    double? rating,
    String? jamBuka,
    String? hargaTiket,
  }) {
    return WisataModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      daerah: daerah ?? this.daerah,
      provinsi: provinsi ?? this.provinsi,
      deskripsi: deskripsi ?? this.deskripsi,
      kategori: kategori ?? this.kategori,
      noHp: noHp ?? this.noHp,
      namaKontak: namaKontak ?? this.namaKontak,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gambarUrl: gambarUrl ?? this.gambarUrl,
      rating: rating ?? this.rating,
      jamBuka: jamBuka ?? this.jamBuka,
      hargaTiket: hargaTiket ?? this.hargaTiket,
      createdAt: createdAt,
    );
  }

  // toString: untuk debug / print di console
  @override
  String toString() => 'WisataModel(id: $id, nama: $nama, daerah: $daerah)';
}
