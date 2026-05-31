// ============================================================
// BAGIAN 7: ADD/EDIT SCREEN — dengan preview WhatsApp
// File: lib/screens/add_edit_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/wisata_model.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/url_helper.dart';
import '../widgets/whatsapp_button.dart';

class AddEditScreen extends StatefulWidget {
  final WisataModel? wisata;
  const AddEditScreen({super.key, this.wisata});
  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseHelper();
  bool _isLoading = false;

  late TextEditingController _namaCtrl, _daerahCtrl, _provinsiCtrl;
  late TextEditingController _deskripsiCtrl, _noHpCtrl, _namaKontakCtrl;
  late TextEditingController _latCtrl, _lngCtrl, _gambarUrlCtrl;
  late TextEditingController _jamBukaCtrl, _hargaTiketCtrl, _ratingCtrl;

  String _selectedKategori = AppConstants.kategoriList.first;
  bool get _isEditing => widget.wisata != null;

  // Untuk preview WhatsApp sebelum simpan
  String get _previewNamaKontak => _namaKontakCtrl.text.trim().isEmpty ? 'Kontak' : _namaKontakCtrl.text.trim();
  String get _previewNamaWisata => _namaCtrl.text.trim().isEmpty ? 'Destinasi' : _namaCtrl.text.trim();
  String get _previewDaerah     => _daerahCtrl.text.trim().isEmpty ? '-' : _daerahCtrl.text.trim();
  String get _previewNoHp       => _noHpCtrl.text.trim();

  @override
  void initState() {
    super.initState();
    final w = widget.wisata;
    _namaCtrl       = TextEditingController(text: w?.nama ?? '');
    _daerahCtrl     = TextEditingController(text: w?.daerah ?? '');
    _provinsiCtrl   = TextEditingController(text: w?.provinsi ?? 'Sulawesi Selatan');
    _deskripsiCtrl  = TextEditingController(text: w?.deskripsi ?? '');
    _noHpCtrl       = TextEditingController(text: w?.noHp ?? '');
    _namaKontakCtrl = TextEditingController(text: w?.namaKontak ?? '');
    _latCtrl        = TextEditingController(text: w?.latitude.toString() ?? '');
    _lngCtrl        = TextEditingController(text: w?.longitude.toString() ?? '');
    _gambarUrlCtrl  = TextEditingController(text: w?.gambarUrl ?? '');
    _jamBukaCtrl    = TextEditingController(text: w?.jamBuka ?? '');
    _hargaTiketCtrl = TextEditingController(text: w?.hargaTiket ?? '');
    _ratingCtrl     = TextEditingController(text: w?.rating.toString() ?? '0.0');
    _selectedKategori = w?.kategori ?? AppConstants.kategoriList.first;

    // Rebuild saat field kontak berubah agar preview update
    _namaKontakCtrl.addListener(() => setState(() {}));
    _namaCtrl.addListener(() => setState(() {}));
    _daerahCtrl.addListener(() => setState(() {}));
    _noHpCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_namaCtrl, _daerahCtrl, _provinsiCtrl, _deskripsiCtrl,
                     _noHpCtrl, _namaKontakCtrl, _latCtrl, _lngCtrl,
                     _gambarUrlCtrl, _jamBukaCtrl, _hargaTiketCtrl, _ratingCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final model = WisataModel(
      id          : widget.wisata?.id ?? 0,
      nama        : _namaCtrl.text.trim(),
      daerah      : _daerahCtrl.text.trim(),
      provinsi    : _provinsiCtrl.text.trim(),
      deskripsi   : _deskripsiCtrl.text.trim(),
      kategori    : _selectedKategori,
      noHp        : _noHpCtrl.text.trim(),
      namaKontak  : _namaKontakCtrl.text.trim(),
      latitude    : double.tryParse(_latCtrl.text) ?? 0,
      longitude   : double.tryParse(_lngCtrl.text) ?? 0,
      gambarUrl   : _gambarUrlCtrl.text.trim().isEmpty ? null : _gambarUrlCtrl.text.trim(),
      jamBuka     : _jamBukaCtrl.text.trim(),
      hargaTiket  : _hargaTiketCtrl.text.trim(),
      rating      : double.tryParse(_ratingCtrl.text) ?? 0,
      createdAt   : widget.wisata?.createdAt ?? DateTime.now(),
    );

    try {
      if (_isEditing) await _db.updateWisata(model);
      else            await _db.insertWisata(model);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_isEditing ? 'Destinasi berhasil diperbarui' : 'Destinasi berhasil ditambahkan!'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Destinasi' : 'Tambah Destinasi Wisata'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [

          // ── 1. Informasi Dasar ────────────────────────────
          _sectionHeader('Informasi Dasar', Icons.info_outline_rounded),
          _card([
            _field(_namaCtrl, 'Nama Destinasi', Icons.landscape_rounded, required: true),
            const SizedBox(height: 12),
            _field(_daerahCtrl, 'Daerah/Kota', Icons.location_city_rounded, required: true),
            const SizedBox(height: 12),
            _field(_provinsiCtrl, 'Provinsi', Icons.map_rounded, required: true),
            const SizedBox(height: 12),
            _kategoriPicker(),
          ]),
          const SizedBox(height: 16),

          // ── 2. Deskripsi ──────────────────────────────────
          _sectionHeader('Deskripsi', Icons.description_rounded),
          _card([
            _field(_deskripsiCtrl, 'Deskripsi Destinasi', Icons.notes_rounded,
                required: true, maxLines: 4),
          ]),
          const SizedBox(height: 16),

          // ── 3. Informasi Kunjungan ────────────────────────
          _sectionHeader('Informasi Kunjungan', Icons.access_time_rounded),
          _card([
            _field(_jamBukaCtrl, 'Jam Buka (misal: 08:00 - 17:00)', Icons.schedule_rounded, required: true),
            const SizedBox(height: 12),
            _field(_hargaTiketCtrl, 'Harga Tiket (misal: Rp 20.000 / Gratis)',
                Icons.confirmation_number_rounded, required: true),
            const SizedBox(height: 12),
            _field(_ratingCtrl, 'Rating (0.0 - 5.0)', Icons.star_rounded,
                keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),

          // ── 4. Kontak + Preview WhatsApp ──────────────────
          _sectionHeader('Kontak', Icons.contact_phone_rounded),
          _card([
            _field(_namaKontakCtrl, 'Nama Kontak/Pengelola', Icons.person_rounded, required: true),
            const SizedBox(height: 12),
            _field(_noHpCtrl, 'Nomor WhatsApp (misal: +6281234567890)',
                Icons.phone_rounded, required: true,
                keyboardType: TextInputType.phone, hint: '+628XXXXXXXXXX'),
            const SizedBox(height: 16),

            // ★ Preview kartu kontak & tombol WhatsApp ★
            _buildContactPreview(),
          ]),
          const SizedBox(height: 16),

          // ── 5. Lokasi & Media ─────────────────────────────
          _sectionHeader('Lokasi & Media', Icons.place_rounded),
          _card([
            Row(children: [
              Expanded(child: _field(_latCtrl, 'Latitude', Icons.my_location_rounded,
                  required: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  hint: '-5.1338')),
              const SizedBox(width: 12),
              Expanded(child: _field(_lngCtrl, 'Longitude', Icons.my_location_rounded,
                  required: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  hint: '119.4062')),
            ]),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: AppTheme.primary),
                const SizedBox(width: 6),
                Expanded(child: Text(
                  'Koordinat dari Google Maps: klik kanan lokasi → "What\'s here"',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600))),
              ]),
            ),
            const SizedBox(height: 12),
            _field(_gambarUrlCtrl, 'URL Foto (opsional)', Icons.image_rounded,
                hint: 'https://example.com/foto.jpg'),
          ]),
          const SizedBox(height: 24),

          // ── Tombol Simpan ─────────────────────────────────
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_isEditing ? Icons.save_rounded : Icons.add_location_alt_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(_isEditing ? 'Simpan Perubahan' : 'Tambah Destinasi',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
            ),
          ),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  // ── Preview kartu kontak & tombol uji WhatsApp ────────────
  Widget _buildContactPreview() {
    final hasPhone = _previewNoHp.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Label
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.greenWA.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.preview_rounded, size: 12, color: AppTheme.greenWA),
            SizedBox(width: 4),
            Text('Preview Kontak', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.greenWA)),
          ]),
        ),
      ]),
      const SizedBox(height: 10),
      // Kartu preview
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppTheme.greenWA.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_rounded, color: AppTheme.greenWA, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_previewNamaKontak,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              Text(hasPhone ? _previewNoHp : 'Belum diisi',
                  style: TextStyle(fontSize: 12,
                      color: hasPhone ? Colors.grey.shade500 : Colors.orange.shade400)),
            ])),
          ]),
          const SizedBox(height: 10),
          // Tombol uji WhatsApp
          hasPhone
              ? WhatsAppButton.full(
                  phoneNumber: _previewNoHp,
                  namaKontak: _previewNamaKontak,
                  namaWisata: _previewNamaWisata,
                  daerah: _previewDaerah,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.chat_rounded, color: Colors.grey.shade400, size: 16),
                    const SizedBox(width: 6),
                    Text('Isi nomor WhatsApp untuk uji coba',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                  ]),
                ),
          if (hasPhone) ...[
            const SizedBox(height: 6),
            Text(
              '↑ Klik untuk uji coba sebelum menyimpan',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ]),
      ),
    ]);
  }

  // ── Helper Widgets ─────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(icon, size: 16, color: AppTheme.primary), const SizedBox(width: 6),
      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primary)),
    ]),
  );

  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(children: children),
  );

  Widget _field(TextEditingController ctrl, String label, IconData icon, {
    bool required = false, int maxLines = 1,
    TextInputType keyboardType = TextInputType.text, String? hint,
  }) => TextFormField(
    controller: ctrl, maxLines: maxLines, keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label, hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    ),
    validator: required
        ? (v) => (v == null || v.trim().isEmpty) ? '$label tidak boleh kosong' : null
        : null,
  );

  Widget _kategoriPicker() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text('Kategori',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500))),
    Wrap(spacing: 8, runSpacing: 8, children: AppConstants.kategoriList.map((k) {
      final selected = _selectedKategori == k;
      final color = AppTheme.getKategoriColor(k);
      return GestureDetector(
        onTap: () => setState(() => _selectedKategori = k),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? color : color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(AppTheme.getKategoriIcon(k), size: 14, color: selected ? Colors.white : color),
            const SizedBox(width: 4),
            Text(k, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : color)),
          ]),
        ),
      );
    }).toList()),
  ]);
}
