// ============================================================
// BAGIAN 4B: WIDGET — WisataCard (dengan tombol WhatsApp)
// File: lib/widgets/wisata_card.dart
// ============================================================

import 'package:flutter/material.dart';
import '../models/wisata_model.dart';
import '../utils/app_theme.dart';
import 'whatsapp_button.dart';

class WisataCard extends StatelessWidget {
  final WisataModel wisata;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const WisataCard({
    super.key,
    required this.wisata,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getKategoriColor(wisata.kategori);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Gambar
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: SizedBox(
                    width: 110, height: 140,
                    child: wisata.gambarUrl != null
                        ? Image.network(wisata.gambarUrl!, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(color))
                        : _placeholder(color),
                  ),
                ),
                // Konten
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Baris atas: badge kategori + rating
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(AppTheme.getKategoriIcon(wisata.kategori), size: 11, color: color),
                              const SizedBox(width: 3),
                              Text(wisata.kategori, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
                            ]),
                          ),
                          const Spacer(),
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(wisata.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                        ]),
                        const SizedBox(height: 6),
                        // Nama
                        Text(wisata.nama,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary, letterSpacing: -0.3),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        // Lokasi
                        Row(children: [
                          Icon(Icons.location_on_rounded, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 3),
                          Expanded(child: Text('${wisata.daerah}, ${wisata.provinsi}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                              maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ]),
                        const SizedBox(height: 6),
                        // Harga
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(wisata.hargaTiket,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        const SizedBox(height: 8),
                        // Baris bawah: WhatsApp mini + tombol hapus + arrow
                        Row(children: [
                          // ★ Tombol WhatsApp mini langsung di card ★
                          WhatsAppButton.mini(
                            phoneNumber: wisata.noHp,
                            namaKontak: wisata.namaKontak,
                            namaWisata: wisata.nama,
                            daerah: wisata.daerah,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                              child: Icon(Icons.delete_outline_rounded, size: 15, color: Colors.red.shade400),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppTheme.primary),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(Color color) => Container(
    color: color.withOpacity(0.12),
    child: Center(child: Icon(AppTheme.getKategoriIcon(wisata.kategori), size: 36, color: color.withOpacity(0.5))),
  );
}
