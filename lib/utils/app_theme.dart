// ============================================================
// BAGIAN 3: TEMA & KONSTANTA APLIKASI
// File: lib/utils/app_theme.dart
//
// Konsep yang dipelajari:
// - ThemeData Flutter
// - Static methods & constants
// - Map<String, T> untuk lookup data
// - Color scheme
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  // --- Definisi Warna Utama ---
  // const: nilai tetap, tidak berubah, dievaluasi saat compile
  static const Color primary = Color(0xFF0F4C75);
  static const Color primaryLight = Color(0xFF1B6CA8);
  static const Color accent = Color(0xFFFF6B35);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color success = Color(0xFF10B981);
  static const Color greenWA = Color(0xFF25D366);

  // --- Map: Kategori → Warna ---
  // Map<String, Color>: kunci adalah nama kategori, nilai adalah warna
  static final Map<String, Color> kategoriColors = {
    'Pantai': const Color(0xFF0EA5E9),
    'Alam': const Color(0xFF22C55E),
    'Danau': const Color(0xFF6366F1),
    'Pulau': const Color(0xFF14B8A6),
    'Budaya': const Color(0xFFF59E0B),
    'Sejarah': const Color(0xFFEF4444),
    'Kuliner': const Color(0xFFEC4899),
    'Lainnya': const Color(0xFF8B5CF6),
  };

  // --- Map: Kategori → Icon ---
  static final Map<String, IconData> kategoriIcons = {
    'Pantai': Icons.beach_access_rounded,
    'Alam': Icons.forest_rounded,
    'Danau': Icons.water_rounded,
    'Pulau': Icons.sailing_rounded,
    'Budaya': Icons.temple_hindu_rounded,
    'Sejarah': Icons.castle_rounded,
    'Kuliner': Icons.restaurant_rounded,
    'Lainnya': Icons.place_rounded,
  };

  // --- Helper Methods ---
  // Mengembalikan warna kategori, default jika tidak ditemukan
  static Color getKategoriColor(String kategori) =>
      kategoriColors[kategori] ?? const Color(0xFF8B5CF6);

  static IconData getKategoriIcon(String kategori) =>
      kategoriIcons[kategori] ?? Icons.place_rounded;

  // --- ThemeData: konfigurasi tampilan seluruh app ---
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}
