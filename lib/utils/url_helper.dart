// ============================================================
// BAGIAN 3C: URL HELPER — Flutter Web Edition
// File: lib/utils/url_helper.dart
//
// Untuk Flutter Web: gunakan launchUrl dengan LaunchMode.platformDefault
// agar link terbuka di tab baru browser (Chrome).
// ============================================================

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {

  // ── WhatsApp ────────────────────────────────────────────────
  // Membuka WhatsApp Web (di browser) atau app WhatsApp (di mobile)
  static Future<void> openWhatsApp({
    required String phoneNumber,
    String message = 'Halo, saya tertarik dengan informasi wisata ini.',
  }) async {
    // Bersihkan nomor: hapus spasi, kurung, tanda hubung
    String phone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    // Ubah awalan 0 → +62
    if (phone.startsWith('0')) phone = '+62${phone.substring(1)}';
    // Pastikan ada tanda + di depan
    if (!phone.startsWith('+')) phone = '+$phone';

    final encoded = Uri.encodeComponent(message);

    // Di web → buka wa.me (WhatsApp Web)
    // Di mobile → bisa pakai whatsapp:// scheme
    final url = kIsWeb
        ? 'https://wa.me/$phone?text=$encoded'
        : 'https://wa.me/$phone?text=$encoded';

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        // webOnlyWindowName: '_blank' → buka di tab baru (khusus web)
        webOnlyWindowName: '_blank',
        mode: LaunchMode.platformDefault,
      );
    } else {
      // Fallback: coba buka langsung lewat window.open di web
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── Google Maps ─────────────────────────────────────────────
  static Future<void> openGoogleMaps({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, webOnlyWindowName: '_blank', mode: LaunchMode.platformDefault);
    }
  }

  // ── Telepon (hanya mobile, di web tidak berlaku) ─────────────
  static Future<void> callPhone(String phoneNumber) async {
    if (kIsWeb) {
      // Di web, alihkan ke WhatsApp saja
      await openWhatsApp(phoneNumber: phoneNumber);
      return;
    }
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
