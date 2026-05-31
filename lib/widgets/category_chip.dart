// ============================================================
// BAGIAN 4: WIDGET - CategoryChip
// File: lib/widgets/category_chip.dart
//
// Konsep yang dipelajari:
// - StatelessWidget: widget yang tidak punya state sendiri
// - AnimatedContainer: animasi otomatis saat properti berubah
// - Callback (VoidCallback): fungsi yang dikirim sebagai parameter
// ============================================================

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class CategoryChip extends StatelessWidget {
  final String label;       // teks kategori
  final bool isSelected;    // apakah sedang dipilih
  final VoidCallback onTap; // fungsi yang dipanggil saat diklik

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan label
    final color = label == 'Semua'
        ? AppTheme.primary
        : AppTheme.getKategoriColor(label);

    return GestureDetector(
      onTap: onTap,
      // AnimatedContainer: berubah tampilan secara smooth saat isSelected berubah
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          // Jika dipilih: background berwarna, jika tidak: putih
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: 1.5,
          ),
          // Shadow hanya muncul saat dipilih
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon hanya muncul untuk kategori selain "Semua"
            if (label != 'Semua') ...[
              Icon(
                AppTheme.getKategoriIcon(label),
                size: 13,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
