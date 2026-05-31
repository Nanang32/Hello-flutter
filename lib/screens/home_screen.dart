// ============================================================
// BAGIAN 5: HOME SCREEN
// File: lib/screens/home_screen.dart
//
// Konsep yang dipelajari:
// - StatefulWidget & State lifecycle (initState, dispose)
// - setState: memperbarui tampilan saat data berubah
// - async/await: memanggil operasi asinkron (database)
// - CustomScrollView + SliverAppBar (collapsible header)
// - TextEditingController: mengelola input teks
// - Navigator.push & hasil return dari halaman lain
// ============================================================

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/wisata_model.dart';
import '../utils/app_theme.dart';
import '../widgets/wisata_card.dart';
import '../widgets/category_chip.dart';
import 'detail_screen.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// State untuk HomeScreen
// Semua variabel yang bisa berubah & mempengaruhi tampilan diletakkan di sini
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Instansiasi DatabaseHelper (Singleton - hanya 1 instance)
  final DatabaseHelper _db = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();

  // Data state
  List<WisataModel> _allWisata = [];       // semua data dari "database"
  List<WisataModel> _filteredWisata = [];  // data yang ditampilkan (sudah difilter)
  String _selectedKategori = 'Semua';
  bool _isLoading = true;                  // loading state untuk shimmer effect

  // Daftar filter kategori (termasuk "Semua")
  final List<String> _kategoriFilter = [
    'Semua', 'Pantai', 'Alam', 'Danau', 'Pulau',
    'Budaya', 'Sejarah', 'Kuliner', 'Lainnya',
  ];

  // --- Lifecycle Methods ---

  @override
  void initState() {
    super.initState();
    // Dipanggil sekali saat widget pertama dibuat
    _loadData();
    // Daftarkan listener: setiap kali teks berubah, panggil _filterData
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    // WAJIB: bersihkan controller saat widget dihapus dari tree
    // Mencegah memory leak
    _searchController.dispose();
    super.dispose();
  }

  // --- Data Methods ---

  // Memuat semua data dari "database"
  Future<void> _loadData() async {
    setState(() => _isLoading = true);    // tampilkan loading
    final data = await _db.getAllWisata(); // async: tunggu sampai selesai
    setState(() {
      _allWisata = data;
      _filteredWisata = data;
      _isLoading = false;                 // sembunyikan loading
    });
  }

  // Filter data berdasarkan teks pencarian DAN kategori yang dipilih
  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredWisata = _allWisata.where((w) {
        // Cocok dengan pencarian teks?
        final matchSearch = query.isEmpty ||
            w.nama.toLowerCase().contains(query) ||
            w.daerah.toLowerCase().contains(query) ||
            w.provinsi.toLowerCase().contains(query);
        // Cocok dengan kategori yang dipilih?
        final matchKategori =
            _selectedKategori == 'Semua' || w.kategori == _selectedKategori;
        // Data ditampilkan hanya jika KEDUA kondisi terpenuhi
        return matchSearch && matchKategori;
      }).toList();
    });
  }

  void _selectKategori(String kategori) {
    setState(() => _selectedKategori = kategori);
    _filterData();
  }

  // --- Navigation Methods ---

  // Navigasi ke halaman tambah
  // `await` digunakan karena kita menunggu hasil dari halaman yang dibuka
  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditScreen()),
    );
    // Jika halaman Add mengembalikan `true`, reload data
    if (result == true) _loadData();
  }

  Future<void> _navigateToDetail(WisataModel wisata) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(wisata: wisata)),
    );
    if (result == true) _loadData();
  }

  Future<void> _deleteWisata(WisataModel wisata) async {
    // Tampilkan dialog konfirmasi sebelum menghapus
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Destinasi'),
        content: Text('Yakin ingin menghapus "${wisata.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _db.deleteWisata(wisata.id);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${wisata.nama} berhasil dihapus'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // --- Build Methods (UI) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildSearchAndFilter()),
          _buildWisataList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAdd,
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt_rounded, size: 22),
        label: const Text(
          'Tambah Wisata',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // SliverAppBar: header yang collapsible (mengecil saat scroll)
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,    // tetap terlihat saat di-scroll
      stretch: true,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F4C75),
                    Color(0xFF1B6CA8),
                    Color(0xFF0EA5E9),
                  ],
                ),
              ),
            ),
            // Konten di bagian bawah header
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.explore_rounded,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wisata Nusantara',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Sulawesi Selatan & Sekitarnya',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStatsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Baris statistik (jumlah destinasi, kategori, daerah)
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatChip(Icons.place_rounded, '${_allWisata.length} Destinasi'),
        const SizedBox(width: 8),
        _buildStatChip(Icons.category_rounded,
            '${_allWisata.map((w) => w.kategori).toSet().length} Kategori'),
        const SizedBox(width: 8),
        _buildStatChip(Icons.location_city_rounded,
            '${_allWisata.map((w) => w.daerah).toSet().length} Daerah'),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Section pencarian + filter kategori
  Widget _buildSearchAndFilter() {
    return Container(
      color: AppTheme.primary,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari destinasi wisata...',
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Colors.grey.shade400, size: 22),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: Colors.grey.shade400),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            // Filter chips (horizontal scrollable)
            SizedBox(
              height: 40,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: _kategoriFilter.length,
                itemBuilder: (context, index) {
                  final kategori = _kategoriFilter[index];
                  return CategoryChip(
                    label: kategori,
                    isSelected: _selectedKategori == kategori,
                    onTap: () => _selectKategori(kategori),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Label hasil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    _searchController.text.isEmpty &&
                            _selectedKategori == 'Semua'
                        ? 'Semua Destinasi'
                        : 'Hasil Pencarian',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${_filteredWisata.length}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Sliver list untuk data wisata
  Widget _buildWisataList() {
    // Tampilkan shimmer/loading
    if (_isLoading) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const _ShimmerCard(),
          childCount: 5,
        ),
      );
    }

    // Tampilkan pesan kosong
    if (_filteredWisata.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                'Tidak ada destinasi ditemukan',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain atau tambah destinasi baru',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      );
    }

    // Tampilkan daftar card
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final wisata = _filteredWisata[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: WisataCard(
                wisata: wisata,
                onTap: () => _navigateToDetail(wisata),
                onDelete: () => _deleteWisata(wisata),
              ),
            );
          },
          childCount: _filteredWisata.length,
        ),
      ),
    );
  }
}

// ============================================================
// Widget ShimmerCard (Loading Skeleton)
// Ditampilkan saat data sedang dimuat
// ============================================================
class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard();

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(); // animasi berulang terus
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(height: 16, width: 160, color: Colors.grey.shade200),
                      Container(height: 12, width: 100, color: Colors.grey.shade200),
                      Container(height: 12, width: 120, color: Colors.grey.shade200),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
