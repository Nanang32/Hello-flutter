# 📱 Wisata Nusantara — Panduan Belajar Flutter Web
## Untuk Mahasiswa: Penjelasan Tahap per Tahap

---

## 🏗️ Struktur Proyek

```
wisata_app/
├── lib/
│   ├── main.dart                    ← Bagian 0: Entry Point
│   ├── models/
│   │   └── wisata_model.dart        ← Bagian 1: Model Data
│   ├── database/
│   │   └── database_helper.dart     ← Bagian 2: Database (Array)
│   ├── utils/
│   │   ├── app_theme.dart           ← Bagian 3: Tema & Warna
│   │   ├── app_constants.dart       ← Bagian 3: Konstanta
│   │   └── url_helper.dart          ← Bagian 3: Helper URL
│   ├── widgets/
│   │   ├── category_chip.dart       ← Bagian 4: Widget Chip
│   │   └── wisata_card.dart         ← Bagian 4: Widget Card
│   └── screens/
│       ├── home_screen.dart         ← Bagian 5: Halaman Utama
│       ├── detail_screen.dart       ← Bagian 6: Halaman Detail + Peta
│       └── add_edit_screen.dart     ← Bagian 7: Form Tambah/Edit
├── pubspec.yaml                     ← Konfigurasi package
└── web/
    └── index.html                   ← Entry HTML untuk web
```

---

## 📦 Dependencies (pubspec.yaml)

| Package | Versi | Fungsi |
|---------|-------|--------|
| `flutter_map` | ^6.1.0 | Peta Leaflet/OpenStreetMap (**ganti Google Maps**) |
| `latlong2` | ^0.9.0 | Koordinat LatLng untuk flutter_map |
| `url_launcher` | ^6.3.0 | Buka URL, telepon, WhatsApp |
| `flutter_animate` | ^4.5.0 | Animasi widget |

> ❌ **Dihapus**: `sqflite`, `path`, `google_maps_flutter`, `cached_network_image`, `image_picker`, `shimmer`, `lottie`
> ✅ **Alasan**: sqflite & google_maps_flutter tidak support Flutter Web

---

## 🔄 Perbedaan Utama dari Versi Mobile

### 1. Database: sqflite → Array (List)

| Versi Mobile (sqflite) | Versi Web (Array) |
|------------------------|-------------------|
| `await db.query('wisata')` | `_data.where(...)` |
| `await db.insert('wisata', map)` | `_data.add(wisata)` |
| `await db.update(...)` | `_data[index] = wisata` |
| `await db.delete(...)` | `_data.removeWhere(...)` |
| Data **persisten** (tersimpan) | Data **hilang saat refresh** |

```dart
// SEBELUM (sqflite - mobile):
Future<List<WisataModel>> getAllWisata() async {
  final db = await database;
  final maps = await db.query('wisata', orderBy: 'created_at DESC');
  return maps.map((map) => WisataModel.fromMap(map)).toList();
}

// SESUDAH (array - web):
Future<List<WisataModel>> getAllWisata() async {
  final sorted = List<WisataModel>.from(_data);
  sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted;
}
```

### 2. Peta: Google Maps → Leaflet (flutter_map)

| Versi Mobile | Versi Web |
|--------------|-----------|
| `google_maps_flutter` | `flutter_map` |
| Butuh API Key Google | **Gratis, tanpa API Key** |
| `GoogleMap(...)` | `FlutterMap(...)` |
| `LatLng` (google) | `LatLng` (latlong2) |

```dart
// SEBELUM (google_maps_flutter):
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(lat, lng), zoom: 14,
  ),
  markers: { Marker(markerId: ..., position: ...) },
)

// SESUDAH (flutter_map / Leaflet):
FlutterMap(
  options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 14),
  children: [
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    ),
    MarkerLayer(markers: [ Marker(point: LatLng(lat, lng), child: Icon(...)) ]),
  ],
)
```

---

## 📚 Bagian 1 — Model Data (`wisata_model.dart`)

### Konsep: Dart Class

```dart
class WisataModel {
  final int id;       // final: tidak bisa diubah setelah dibuat
  final String nama;
  // ...

  // Constructor dengan named parameters (required/optional)
  const WisataModel({
    required this.id,    // wajib diisi
    required this.nama,
    this.gambarUrl,      // opsional (nullable)
    this.rating = 0.0,  // opsional dengan default value
  });

  // copyWith: cara update objek immutable
  WisataModel copyWith({String? nama, ...}) {
    return WisataModel(
      id: id,               // tetap pakai nilai lama
      nama: nama ?? this.nama,  // pakai nilai baru jika ada
    );
  }
}
```

### Mengapa `final`?
- Membuat objek **immutable** (tidak bisa berubah)
- Lebih aman karena tidak ada perubahan tidak sengaja
- Gunakan `copyWith()` untuk membuat versi baru dengan perubahan

---

## 📚 Bagian 2 — Database Array (`database_helper.dart`)

### Konsep: Singleton Pattern

```dart
class DatabaseHelper {
  // 1. Instance statis private (dibuat sekali, disimpan di sini)
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // 2. Constructor private (mencegah pembuatan instance dari luar)
  DatabaseHelper._internal();

  // 3. Factory constructor (selalu return instance yang sama)
  factory DatabaseHelper() => _instance;
}

// Penggunaan:
final db1 = DatabaseHelper();
final db2 = DatabaseHelper();
print(db1 == db2); // true! Keduanya objek yang sama
```

### Mengapa Singleton?
- Database hanya boleh ada **satu** di seluruh aplikasi
- Semua halaman berbagi data yang sama
- Mencegah data tidak sinkron

### CRUD dengan List

```dart
// CREATE
_data.add(wisata);

// READ (filter)
_data.where((w) => w.kategori == 'Pantai').toList();

// UPDATE
final index = _data.indexWhere((w) => w.id == wisata.id);
_data[index] = wisata;

// DELETE
_data.removeWhere((w) => w.id == id);
```

---

## 📚 Bagian 3 — Tema & Konstanta

### Konsep: Static + Map Lookup

```dart
class AppTheme {
  // const: dievaluasi saat compile, lebih efisien
  static const Color primary = Color(0xFF0F4C75);

  // Map<String, Color>: lookup warna berdasarkan nama kategori
  static final Map<String, Color> kategoriColors = {
    'Pantai': Color(0xFF0EA5E9),
    'Alam': Color(0xFF22C55E),
  };

  // Helper method: return warna atau default jika tidak ditemukan
  static Color getKategoriColor(String kategori) =>
      kategoriColors[kategori] ?? const Color(0xFF8B5CF6);
}

// Penggunaan:
Color warnaPantai = AppTheme.getKategoriColor('Pantai'); // 0xFF0EA5E9
Color warnaUnknown = AppTheme.getKategoriColor('xyz');   // 0xFF8B5CF6 (default)
```

---

## 📚 Bagian 4 — Widget Reusable

### Konsep: StatelessWidget vs StatefulWidget

| StatelessWidget | StatefulWidget |
|----------------|----------------|
| Tidak punya state | Punya state yang bisa berubah |
| Tidak bisa `setState()` | Bisa `setState()` |
| Lebih efisien | Sedikit lebih berat |
| Cocok untuk tampilan statis | Cocok untuk tampilan dinamis |

```dart
// StatelessWidget: CategoryChip
// Tidak ada data yang berubah di dalamnya
// Perubahan datang dari luar (via parameter)
class CategoryChip extends StatelessWidget {
  final bool isSelected;  // diterima dari luar
  // ...
}

// StatefulWidget: HomeScreen
// Punya data internal yang berubah (_filteredWisata, _isLoading, dll)
class HomeScreen extends StatefulWidget { ... }
class _HomeScreenState extends State<HomeScreen> {
  List<WisataModel> _filteredWisata = [];
  bool _isLoading = true;

  void _filterData() {
    setState(() {    // panggil setState agar Flutter rebuild widget
      _filteredWisata = ...;
    });
  }
}
```

### Konsep: Callback (VoidCallback)

```dart
// Di WisataCard: menerima fungsi sebagai parameter
class WisataCard extends StatelessWidget {
  final VoidCallback onTap;     // fungsi tanpa parameter, tanpa return
  final VoidCallback onDelete;
}

// Di HomeScreen: mengirim fungsi
WisataCard(
  wisata: wisata,
  onTap: () => _navigateToDetail(wisata),  // lambda function
  onDelete: () => _deleteWisata(wisata),
)
```

---

## 📚 Bagian 5 — Home Screen

### Konsep: Lifecycle Widget

```
initState()  → dipanggil SEKALI saat widget dibuat
build()      → dipanggil setiap kali setState() dipanggil
dispose()    → dipanggil SEKALI saat widget dihapus
```

```dart
@override
void initState() {
  super.initState();          // WAJIB panggil super
  _loadData();                // muat data pertama kali
  _searchController.addListener(_filterData);  // listen perubahan teks
}

@override
void dispose() {
  _searchController.dispose();  // WAJIB bersihkan controller
  super.dispose();               // WAJIB panggil super
}
```

### Konsep: async/await

```dart
Future<void> _loadData() async {
  setState(() => _isLoading = true);

  // await: tunggu sampai operasi selesai sebelum lanjut
  final data = await _db.getAllWisata();

  setState(() {
    _allWisata = data;
    _isLoading = false;
  });
}
```

### Konsep: Navigator & Return Value

```dart
// Kirim ke halaman lain & tunggu hasilnya
Future<void> _navigateToAdd() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddEditScreen()),
  );
  // result adalah nilai yang dikirim saat Navigator.pop(context, nilai)
  if (result == true) _loadData(); // reload jika ada data baru
}

// Di AddEditScreen, setelah simpan berhasil:
Navigator.pop(context, true); // kirim 'true' kembali ke HomeScreen
```

---

## 📚 Bagian 6 — Detail Screen + Peta Leaflet

### Cara Pakai flutter_map

```dart
// 1. Import
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong2.dart';

// 2. Buat koordinat
final position = LatLng(-5.1338, 119.4062);

// 3. Buat widget peta
FlutterMap(
  options: MapOptions(
    initialCenter: position,  // pusat peta
    initialZoom: 14,          // zoom level
  ),
  children: [
    // Layer 1: Gambar peta dari OpenStreetMap
    TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.wisata_app',
    ),
    // Layer 2: Marker pin lokasi
    MarkerLayer(
      markers: [
        Marker(
          point: position,    // koordinat marker
          width: 50,
          height: 50,
          child: Icon(Icons.place, color: Colors.red),
        ),
      ],
    ),
  ],
)
```

### Kenapa OpenStreetMap?
- ✅ **Gratis** (tidak perlu API key)
- ✅ **Open Source** (data peta bebas digunakan)
- ✅ **Support web** (berbasis HTTP tile, bukan native)
- ✅ **Data lengkap** (komunitas global)

---

## 📚 Bagian 7 — Form Add/Edit

### Konsep: Form Validation

```dart
// 1. Buat GlobalKey
final _formKey = GlobalKey<FormState>();

// 2. Bungkus dengan Form
Form(
  key: _formKey,
  child: Column(children: [
    TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field ini wajib diisi';  // pesan error
        }
        return null;  // null = valid
      },
    ),
  ]),
)

// 3. Validasi saat submit
void _save() {
  if (_formKey.currentState!.validate()) {
    // Semua field valid, lanjut simpan
  }
  // Jika tidak valid, error message otomatis ditampilkan
}
```

### Konsep: Mode Add vs Edit

```dart
class AddEditScreen extends StatefulWidget {
  final WisataModel? wisata;  // null = mode Add, isi = mode Edit
}

// Cek mode
bool get _isEditing => widget.wisata != null;

// Inisialisasi berdasarkan mode
_namaCtrl = TextEditingController(
  text: widget.wisata?.nama ?? '',  // operator ?. dan ??
);
```

---

## 🚀 Cara Menjalankan

```bash
# 1. Install dependencies
flutter pub get

# 2. Jalankan di Chrome (web)
flutter run -d chrome

# 3. Build untuk deploy
flutter build web
# Output di: build/web/
```

---

## 💡 Tips untuk Mahasiswa

### Urutan Belajar yang Disarankan

1. **Baca `wisata_model.dart`** → Pahami struktur data
2. **Baca `database_helper.dart`** → Pahami operasi CRUD
3. **Baca `category_chip.dart`** → StatelessWidget sederhana
4. **Baca `wisata_card.dart`** → StatelessWidget dengan gambar
5. **Baca `home_screen.dart`** → StatefulWidget, async, filter
6. **Baca `detail_screen.dart`** → Navigasi + flutter_map
7. **Baca `add_edit_screen.dart`** → Form validation, CRUD

### Eksperimen yang Bisa Dicoba

- Tambah field baru di `WisataModel` (contoh: `websiteUrl`)
- Ubah warna tema di `AppTheme`
- Tambah filter berdasarkan daerah di `HomeScreen`
- Tampilkan semua marker sekaligus di peta (MapScreen baru)
- Ubah style peta (ada banyak TileLayer alternatif OpenStreetMap)

### TileLayer Alternatif

```dart
// OpenStreetMap (default)
urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'

// CartoDB Positron (lebih bersih/minimalis)
urlTemplate: 'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'

// Stamen Toner (hitam putih)
urlTemplate: 'https://stamen-tiles.a.ssl.fastly.net/toner/{z}/{x}/{y}.png'
```
