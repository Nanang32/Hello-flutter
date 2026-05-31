// ============================================================
// BAGIAN 6: DETAIL SCREEN + PETA LEAFLET
// File: lib/screens/detail_screen.dart
// ============================================================

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/wisata_model.dart';
import '../utils/app_theme.dart';
import '../utils/url_helper.dart';
import '../widgets/whatsapp_button.dart';
import 'add_edit_screen.dart';

class DetailScreen extends StatefulWidget {
  final WisataModel wisata;
  const DetailScreen({super.key, required this.wisata});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(child: Column(children: [
          _buildInfoSection(),
          _buildDescriptionSection(),
          _buildMapSection(),
          _buildContactSection(),   // ← section kontak lengkap
          const SizedBox(height: 120),
        ])),
      ]),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Header foto ────────────────────────────────────────────
  Widget _buildSliverAppBar() {
    final color = AppTheme.getKategoriColor(widget.wisata.kategori);
    return SliverAppBar(
      expandedHeight: 280, pinned: true, backgroundColor: AppTheme.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18)),
      ),
      actions: [
        GestureDetector(
          onTap: _navigateToEdit,
          child: Container(
            margin: const EdgeInsets.all(8), padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
            child: const Row(children: [
              Icon(Icons.edit_rounded, color: Colors.white, size: 16), SizedBox(width: 4),
              Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ])),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          widget.wisata.gambarUrl != null
              ? Image.network(widget.wisata.gambarUrl!, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imgPlaceholder(color))
              : _imgPlaceholder(color),
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54]))),
          Positioned(bottom: 16, left: 16, right: 16, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
                child: Text(widget.wisata.kategori,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
              const SizedBox(height: 8),
              Text(widget.wisata.nama,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14), const SizedBox(width: 4),
                Text('${widget.wisata.daerah}, ${widget.wisata.provinsi}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _imgPlaceholder(Color color) => Container(
    decoration: BoxDecoration(gradient: LinearGradient(
      colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    child: Center(child: Icon(AppTheme.getKategoriIcon(widget.wisata.kategori),
        size: 80, color: Colors.white.withOpacity(0.4))),
  );

  // ── Info row ───────────────────────────────────────────────
  Widget _buildInfoSection() => _card(
    margin: const EdgeInsets.all(16),
    child: Row(children: [
      _infoItem(Icons.star_rounded, widget.wisata.rating.toStringAsFixed(1), 'Rating', const Color(0xFFF59E0B)),
      _dividerV(),
      _infoItem(Icons.access_time_rounded, widget.wisata.jamBuka, 'Jam Buka', AppTheme.primary),
      _dividerV(),
      _infoItem(Icons.confirmation_number_rounded, widget.wisata.hargaTiket, 'Tiket', AppTheme.success),
    ]),
  );

  Widget _infoItem(IconData icon, String value, String label, Color color) =>
    Expanded(child: Column(children: [
      Container(padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
    ]));

  Widget _dividerV() => Container(width: 1, height: 60, color: Colors.grey.shade100, margin: const EdgeInsets.symmetric(horizontal: 8));

  // ── Deskripsi ──────────────────────────────────────────────
  Widget _buildDescriptionSection() => _card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [
        Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.primary), SizedBox(width: 8),
        Text('Tentang Destinasi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
      const SizedBox(height: 10),
      Text(widget.wisata.deskripsi,
          style: const TextStyle(fontSize: 13.5, color: AppTheme.textSecondary, height: 1.6),
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? null : TextOverflow.ellipsis),
      if (widget.wisata.deskripsi.length > 150) ...[
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Text(_isExpanded ? 'Tampilkan lebih sedikit' : 'Selengkapnya',
              style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600, fontSize: 13))),
      ],
    ]),
  );

  // ── Peta Leaflet ───────────────────────────────────────────
  Widget _buildMapSection() {
    final pos = LatLng(widget.wisata.latitude, widget.wisata.longitude);
    return _card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Row(children: [
              Icon(Icons.map_rounded, size: 18, color: AppTheme.primary), SizedBox(width: 8),
              Text('Lokasi di Peta', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ]),
            GestureDetector(
              onTap: () => UrlHelper.openGoogleMaps(latitude: widget.wisata.latitude, longitude: widget.wisata.longitude),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Row(children: [
                  Icon(Icons.open_in_new_rounded, size: 14, color: AppTheme.primary), SizedBox(width: 4),
                  Text('Buka Maps', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ]),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
          child: SizedBox(height: 220,
            child: FlutterMap(
              options: MapOptions(initialCenter: pos, initialZoom: 14,
                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.all)),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.wisata_app',
                ),
                MarkerLayer(markers: [
                  Marker(point: pos, width: 50, height: 50,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppTheme.accent, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: AppTheme.accent.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 3))]),
                        child: const Icon(Icons.place_rounded, color: Colors.white, size: 18),
                      ),
                      CustomPaint(size: const Size(12, 6), painter: _TrianglePainter(AppTheme.accent)),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ── Section Kontak LENGKAP ─────────────────────────────────
  Widget _buildContactSection() => _card(
    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      const Row(children: [
        Icon(Icons.contact_phone_rounded, size: 18, color: AppTheme.primary), SizedBox(width: 8),
        Text('Informasi Kontak', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
      const SizedBox(height: 14),
      // Info kontak
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person_rounded, color: AppTheme.primary, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.wisata.namaKontak,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            const SizedBox(height: 2),
            Text(widget.wisata.noHp, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
          ])),
        ]),
      ),
      const SizedBox(height: 12),
      // ★ Tombol kontak: Telepon + WhatsApp ★
      Row(children: [
        Expanded(child: _contactBtn(Icons.phone_rounded, 'Telepon', AppTheme.primary,
            () => UrlHelper.callPhone(widget.wisata.noHp))),
        const SizedBox(width: 10),
        Expanded(child: _contactBtn(Icons.chat_rounded, 'WhatsApp', AppTheme.greenWA, _openWA)),
      ]),
      const SizedBox(height: 12),
      // ★ Tombol WhatsApp full — lebih menonjol ★
      WhatsAppButton.full(
        phoneNumber: widget.wisata.noHp,
        namaKontak: widget.wisata.namaKontak,
        namaWisata: widget.wisata.nama,
        daerah: widget.wisata.daerah,
      ),
    ]),
  );

  Widget _contactBtn(IconData icon, String label, Color color, VoidCallback onTap) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 17), const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    );

  // ── Bottom bar ─────────────────────────────────────────────
  Widget _buildBottomBar() => Container(
    padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
    decoration: BoxDecoration(color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))]),
    child: Row(children: [
      // Petunjuk arah
      Expanded(child: GestureDetector(
        onTap: () => UrlHelper.openGoogleMaps(latitude: widget.wisata.latitude, longitude: widget.wisata.longitude),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(border: Border.all(color: AppTheme.primary), borderRadius: BorderRadius.circular(12)),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.directions_rounded, color: AppTheme.primary, size: 18), SizedBox(width: 6),
            Text('Petunjuk Arah', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
          ]),
        ),
      )),
      const SizedBox(width: 10),
      // ★ WhatsApp di bottom bar ★
      Expanded(flex: 2, child: GestureDetector(
        onTap: _openWA,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: AppTheme.greenWA, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: AppTheme.greenWA.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.send_rounded, color: Colors.white, size: 18), SizedBox(width: 6),
            Text('Kirim Pesan WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          ]),
        ),
      )),
    ]),
  );

  void _openWA() => UrlHelper.openWhatsApp(
    phoneNumber: widget.wisata.noHp,
    message: 'Halo ${widget.wisata.namaKontak}, saya tertarik mengunjungi '
        '${widget.wisata.nama} di ${widget.wisata.daerah}. Boleh minta informasi lebih lanjut?',
  );

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (_) => AddEditScreen(wisata: widget.wisata)));
    if (result == true && mounted) Navigator.pop(context, true);
  }

  Widget _card({required Widget child, EdgeInsets? margin, EdgeInsets? padding}) =>
    Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      ui.Path()..moveTo(0, 0)..lineTo(size.width / 2, size.height)..lineTo(size.width, 0)..close(),
      Paint()..color = color,
    );
  }
  @override bool shouldRepaint(_) => false;
}
