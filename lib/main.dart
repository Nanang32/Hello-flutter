// ============================================================
// BAGIAN 0: ENTRY POINT APLIKASI
// File: lib/main.dart
//
// Konsep yang dipelajari:
// - void main(): titik masuk program Dart
// - runApp(): menjalankan aplikasi Flutter
// - MaterialApp: root widget dengan konfigurasi tema
// ============================================================

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized() tidak diperlukan karena
  // kita tidak menggunakan plugin native (sqflite sudah dihapus)
  runApp(const WisataApp());
}

class WisataApp extends StatelessWidget {
  const WisataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Nusantara',
      debugShowCheckedModeBanner: false,   // sembunyikan banner "DEBUG"
      theme: AppTheme.theme,               // tema dari AppTheme
      home: const HomeScreen(),            // halaman pertama
    );
  }
}
