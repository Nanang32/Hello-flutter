// ============================================================
// WIDGET REUSABLE: WhatsAppButton
// File: lib/widgets/whatsapp_button.dart
//
// Widget tombol WhatsApp yang bisa dipakai di halaman mana saja.
// Tersedia dalam 3 varian:
//   - WhatsAppButton.full()  → tombol lebar penuh dengan teks
//   - WhatsAppButton.fab()   → floating action button bulat
//   - WhatsAppButton.mini()  → chip kecil dengan icon & teks singkat
// ============================================================

import 'package:flutter/material.dart';
import '../utils/url_helper.dart';
import '../utils/app_theme.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String namaKontak;
  final String namaWisata;
  final String daerah;
  final _Variant _variant;

  // Private constructor
  const WhatsAppButton._({
    super.key,
    required this.phoneNumber,
    required this.namaKontak,
    required this.namaWisata,
    required this.daerah,
    required _Variant variant,
  }) : _variant = variant;

  // ── Named constructors (3 varian) ──────────────────────────

  /// Tombol lebar penuh — cocok untuk bottom bar / section kontak
  const factory WhatsAppButton.full({
    Key? key,
    required String phoneNumber,
    required String namaKontak,
    required String namaWisata,
    required String daerah,
  }) = _FullButton;

  /// Floating button — cocok untuk pojok layar
  const factory WhatsAppButton.fab({
    Key? key,
    required String phoneNumber,
    required String namaKontak,
    required String namaWisata,
    required String daerah,
  }) = _FabButton;

  /// Chip kecil — cocok di dalam card atau list
  const factory WhatsAppButton.mini({
    Key? key,
    required String phoneNumber,
    required String namaKontak,
    required String namaWisata,
    required String daerah,
  }) = _MiniButton;

  // ── Helper: buat pesan WhatsApp ────────────────────────────
  String get _message =>
      'Halo $namaKontak, saya tertarik mengunjungi $namaWisata di $daerah. '
      'Boleh minta informasi lebih lanjut mengenai jam buka dan tiket masuk?';

  void _openWhatsApp() => UrlHelper.openWhatsApp(
    phoneNumber: phoneNumber,
    message: _message,
  );

  @override
  Widget build(BuildContext context) => const SizedBox.shrink(); // override di subclass
}

enum _Variant { full, fab, mini }

// ── Varian 1: Full width button ────────────────────────────
class _FullButton extends WhatsAppButton {
  const _FullButton({
    super.key,
    required super.phoneNumber,
    required super.namaKontak,
    required super.namaWisata,
    required super.daerah,
  }) : super._(variant: _Variant.full);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openWhatsApp,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.greenWA,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greenWA.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Hubungi via WhatsApp',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Varian 2: FAB (Floating Action Button) ─────────────────
class _FabButton extends WhatsAppButton {
  const _FabButton({
    super.key,
    required super.phoneNumber,
    required super.namaKontak,
    required super.namaWisata,
    required super.daerah,
  }) : super._(variant: _Variant.fab);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'wa_fab_$phoneNumber',
      onPressed: _openWhatsApp,
      backgroundColor: AppTheme.greenWA,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.chat_rounded, size: 20),
      label: const Text(
        'WhatsApp',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}

// ── Varian 3: Mini chip ─────────────────────────────────────
class _MiniButton extends WhatsAppButton {
  const _MiniButton({
    super.key,
    required super.phoneNumber,
    required super.namaKontak,
    required super.namaWisata,
    required super.daerah,
  }) : super._(variant: _Variant.mini);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openWhatsApp,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppTheme.greenWA,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greenWA.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_rounded, color: Colors.white, size: 14),
            SizedBox(width: 6),
            Text(
              'WhatsApp',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
