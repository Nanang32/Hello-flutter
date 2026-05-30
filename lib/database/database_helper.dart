// ============================================================
// BAGIAN 2: DATABASE (In-Memory Array)
// File: lib/database/database_helper.dart
//
// Konsep yang dipelajari:
// - Singleton Pattern (satu instance untuk seluruh app)
// - List sebagai "database"
// - CRUD: Create, Read, Update, Delete
// - Metode pencarian & filter
//
// CATATAN: Pada versi asli menggunakan sqflite (SQLite).
// Untuk Flutter Web, kita ganti dengan List<WisataModel>
// karena sqflite TIDAK support web. Data akan hilang saat
// halaman di-refresh (tidak persistent), tapi cocok untuk
// belajar logika CRUD.
// ============================================================

import '../models/wisata_model.dart';

class DatabaseHelper {
  // --- Singleton Pattern ---
  // Hanya boleh ada SATU instance DatabaseHelper di seluruh app
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  DatabaseHelper._internal();                  // private constructor
  factory DatabaseHelper() => _instance;       // factory: selalu return instance yg sama

  // --- "Database" kita: sebuah List ---
  // Diisi dengan data awal (seed data) saat pertama kali dibuat
  final List<WisataModel> _data = _seedData();

  // Counter untuk auto-increment ID (mirip AUTOINCREMENT di SQLite)
  int _nextId = 11; // seed data sudah pakai id 1-10

  // ============================================================
  // DATA AWAL (Seed Data)
  // Ini pengganti INSERT seed data di onCreate SQLite
  // ============================================================
  static List<WisataModel> _seedData() {
    return [
      WisataModel(
        id: 1,
        nama: 'Pantai Losari',
        daerah: 'Makassar',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Pantai Losari adalah salah satu ikon wisata kota Makassar. Terkenal dengan pemandangan matahari terbenam yang memukau dan deretan warung kuliner coto makassar serta pisang epe.',
        kategori: 'Pantai',
        noHp: '+6281234567890',
        namaKontak: 'Dinas Pariwisata Makassar',
        latitude: -5.1338,
        longitude: 119.4062,
        gambarUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Losari_Beach%2C_Makassar.jpg/1200px-Losari_Beach%2C_Makassar.jpg',
        rating: 4.7,
        jamBuka: '24 Jam',
        hargaTiket: 'Gratis',
        createdAt: DateTime(2024, 1, 1),
      ),
      WisataModel(
        id: 2,
        nama: 'Taman Nasional Bantimurung',
        daerah: 'Maros',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Dijuluki "Kerajaan Kupu-Kupu" oleh Alfred Russel Wallace, Bantimurung menawarkan air terjun indah, gua prasejarah, dan ratusan spesies kupu-kupu endemik.',
        kategori: 'Alam',
        noHp: '+6281298765432',
        namaKontak: 'Balai TN Bantimurung',
        latitude: -4.8667,
        longitude: 119.6833,
        gambarUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Bantimurung_waterfall.jpg/1200px-Bantimurung_waterfall.jpg',
        rating: 4.8,
        jamBuka: '08:00 - 17:00',
        hargaTiket: 'Rp 30.000',
        createdAt: DateTime(2024, 1, 2),
      ),
      WisataModel(
        id: 3,
        nama: 'Danau Tempe',
        daerah: 'Wajo',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Danau terbesar di Sulawesi Selatan yang terkenal dengan komunitas nelayan di atas air dan pemandangan sunrise yang spektakuler.',
        kategori: 'Danau',
        noHp: '+6282345678901',
        namaKontak: 'Pengelola Wisata Danau Tempe',
        latitude: -3.9667,
        longitude: 120.0167,
        gambarUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Lake_Tempe%2C_Wajo_Regency.jpg/1200px-Lake_Tempe%2C_Wajo_Regency.jpg',
        rating: 4.5,
        jamBuka: '06:00 - 18:00',
        hargaTiket: 'Rp 15.000',
        createdAt: DateTime(2024, 1, 3),
      ),
      WisataModel(
        id: 4,
        nama: 'Pulau Selayar',
        daerah: 'Selayar',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Surga bawah laut dengan terumbu karang yang masih terjaga, air biru jernih, dan pantai berpasir putih. Gerbang menuju Taman Nasional Takabonerate.',
        kategori: 'Pulau',
        noHp: '+6283456789012',
        namaKontak: 'Dinas Pariwisata Selayar',
        latitude: -6.1167,
        longitude: 120.4500,
        gambarUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
        rating: 4.9,
        jamBuka: '24 Jam',
        hargaTiket: 'Rp 25.000',
        createdAt: DateTime(2024, 1, 4),
      ),
      WisataModel(
        id: 5,
        nama: 'Toraja (Tana Toraja)',
        daerah: 'Rantepao',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Kawasan budaya unik dengan tradisi pemakaman Rambu Solo, rumah adat Tongkonan, dan pemandangan alam pegunungan yang menakjubkan.',
        kategori: 'Budaya',
        noHp: '+6284567890123',
        namaKontak: 'Dinas Pariwisata Tana Toraja',
        latitude: -2.9667,
        longitude: 119.9000,
        gambarUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Tongkonan_houses_in_Tana_Toraja%2C_Sulawesi.jpg/1200px-Tongkonan_houses_in_Tana_Toraja%2C_Sulawesi.jpg',
        rating: 4.9,
        jamBuka: '08:00 - 17:00',
        hargaTiket: 'Rp 50.000',
        createdAt: DateTime(2024, 1, 5),
      ),
      WisataModel(
        id: 6,
        nama: 'Pantai Bira',
        daerah: 'Bulukumba',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Pantai dengan pasir putih halus dan laut biru jernih. Terkenal sebagai tempat pembuatan kapal Phinisi tradisional Bugis-Makassar.',
        kategori: 'Pantai',
        noHp: '+6285678901234',
        namaKontak: 'Pengelola Pantai Bira',
        latitude: -5.6106,
        longitude: 120.4431,
        gambarUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        rating: 4.7,
        jamBuka: '07:00 - 18:00',
        hargaTiket: 'Rp 20.000',
        createdAt: DateTime(2024, 1, 6),
      ),
      WisataModel(
        id: 7,
        nama: 'Rammang-Rammang',
        daerah: 'Maros',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Kawasan karst terbesar ketiga di dunia. Menawarkan wisata sungai dengan perahu kayu melewati tebing-tebing batu gamping yang megah.',
        kategori: 'Alam',
        noHp: '+6286789012345',
        namaKontak: 'Kelompok Sadar Wisata Rammang-Rammang',
        latitude: -4.9667,
        longitude: 119.7000,
        gambarUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        rating: 4.8,
        jamBuka: '07:00 - 17:00',
        hargaTiket: 'Rp 35.000',
        createdAt: DateTime(2024, 1, 7),
      ),
      WisataModel(
        id: 8,
        nama: 'Fort Rotterdam',
        daerah: 'Makassar',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Benteng peninggalan kolonial Belanda abad ke-17 yang menjadi saksi bisu sejarah Kerajaan Gowa-Tallo. Kini menjadi museum dan cagar budaya.',
        kategori: 'Sejarah',
        noHp: '+6287890123456',
        namaKontak: 'Museum Fort Rotterdam',
        latitude: -5.1303,
        longitude: 119.4069,
        gambarUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Fort_Rotterdam_Makassar.jpg/1200px-Fort_Rotterdam_Makassar.jpg',
        rating: 4.6,
        jamBuka: '08:00 - 16:00',
        hargaTiket: 'Rp 5.000',
        createdAt: DateTime(2024, 1, 8),
      ),
      WisataModel(
        id: 9,
        nama: 'Danau Matano',
        daerah: 'Luwu Timur',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Salah satu danau terdalam di dunia (590 meter) dengan air yang sangat jernih. Habitat ikan endemik dan surga bagi penyelam.',
        kategori: 'Danau',
        noHp: '+6288901234567',
        namaKontak: 'Pengelola Wisata Danau Matano',
        latitude: -2.5167,
        longitude: 121.3167,
        gambarUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
        rating: 4.8,
        jamBuka: '06:00 - 18:00',
        hargaTiket: 'Rp 20.000',
        createdAt: DateTime(2024, 1, 9),
      ),
      WisataModel(
        id: 10,
        nama: 'Pulau Samalona',
        daerah: 'Makassar',
        provinsi: 'Sulawesi Selatan',
        deskripsi:
            'Pulau kecil cantik hanya 30 menit dari Makassar. Snorkeling, diving, dan bersantai di pasir putih dengan pemandangan kota Makassar di kejauhan.',
        kategori: 'Pulau',
        noHp: '+6289012345678',
        namaKontak: 'Pengelola Pulau Samalona',
        latitude: -5.1667,
        longitude: 119.3833,
        gambarUrl: 'https://images.unsplash.com/photo-1530541930197-ff16ac917b0e?w=800',
        rating: 4.6,
        jamBuka: '07:00 - 17:00',
        hargaTiket: 'Rp 25.000',
        createdAt: DateTime(2024, 1, 10),
      ),
    ];
  }

  // ============================================================
  // CRUD OPERATIONS
  // Mirip dengan operasi SQL tapi menggunakan metode List Dart
  // ============================================================

  // CREATE - Tambah data baru
  // Mirip: INSERT INTO wisata VALUES (...)
  Future<int> insertWisata(WisataModel wisata) async {
    final newWisata = wisata.copyWith(id: _nextId);
    _data.add(newWisata);
    _nextId++;
    return newWisata.id; // return id yang baru dibuat
  }

  // READ ALL - Ambil semua data
  // Mirip: SELECT * FROM wisata ORDER BY created_at DESC
  Future<List<WisataModel>> getAllWisata() async {
    // Buat salinan list supaya list asli tidak berubah dari luar
    final sorted = List<WisataModel>.from(_data);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  // READ ONE - Ambil satu data berdasarkan ID
  // Mirip: SELECT * FROM wisata WHERE id = ?
  Future<WisataModel?> getWisataById(int id) async {
    try {
      return _data.firstWhere((w) => w.id == id);
    } catch (_) {
      return null; // return null jika tidak ditemukan
    }
  }

  // SEARCH - Cari data berdasarkan keyword
  // Mirip: SELECT * FROM wisata WHERE nama LIKE '%query%' OR daerah LIKE ...
  Future<List<WisataModel>> searchWisata(String query) async {
    final q = query.toLowerCase();
    return _data.where((w) {
      return w.nama.toLowerCase().contains(q) ||
          w.daerah.toLowerCase().contains(q) ||
          w.provinsi.toLowerCase().contains(q) ||
          w.kategori.toLowerCase().contains(q);
    }).toList();
  }

  // FILTER BY KATEGORI
  // Mirip: SELECT * FROM wisata WHERE kategori = ? ORDER BY rating DESC
  Future<List<WisataModel>> getWisataByKategori(String kategori) async {
    final filtered = _data.where((w) => w.kategori == kategori).toList();
    filtered.sort((a, b) => b.rating.compareTo(a.rating));
    return filtered;
  }

  // UPDATE - Perbarui data
  // Mirip: UPDATE wisata SET ... WHERE id = ?
  Future<int> updateWisata(WisataModel wisata) async {
    final index = _data.indexWhere((w) => w.id == wisata.id);
    if (index == -1) return 0; // tidak ditemukan
    _data[index] = wisata;
    return 1; // berhasil update 1 data
  }

  // DELETE - Hapus data
  // Mirip: DELETE FROM wisata WHERE id = ?
  Future<int> deleteWisata(int id) async {
    final before = _data.length;
    _data.removeWhere((w) => w.id == id);
    return _data.length < before ? 1 : 0; // 1 jika berhasil hapus
  }

  // Ambil daftar kategori unik
  // Mirip: SELECT DISTINCT kategori FROM wisata ORDER BY kategori
  Future<List<String>> getKategoriList() async {
    final kategori = _data.map((w) => w.kategori).toSet().toList();
    kategori.sort();
    return kategori;
  }

  // Ambil daftar daerah unik
  Future<List<String>> getDaerahList() async {
    final daerah = _data.map((w) => w.daerah).toSet().toList();
    daerah.sort();
    return daerah;
  }
}
