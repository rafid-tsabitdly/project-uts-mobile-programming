# Soal 4 - Aplikasi Gabungan (Soal 1 + 2 + 3)

Gabungan dari Soal 1, 2, dan 3 dalam satu aplikasi terintegrasi dengan CRUD lengkap.

## Identitas Mahasiswa
| Field | Value |
|---|---|
| Nama | Muhammad Rafid Tsabitdly |
| NIM | 241011701060 |
| Kelas | 04SIFE008 |
| Prodi | Sistem Informasi |
| Universitas | Universitas Pamulang |

## Struktur File
```
lib/
├── main.dart              # Entry point + Salomon Bottom Bar
├── models/
│   └── pertemuan_model.dart
└── pages/
    ├── list_page.dart     # CRUD ListView
    └── profile_page.dart  # Profil LinkedIn-style
```

## Fitur
### Tab Pertemuan (Soal 1)
- ListView 7 pertemuan
- Tambah pertemuan (FAB + Dialog)
- Edit pertemuan (PopupMenu + Dialog)
- Hapus pertemuan (Swipe / PopupMenu + konfirmasi)
- Search/filter real-time
- Progress bar pembelajaran
- Checkbox & badge status

### Tab Profil (Soal 3)
- Design bergaya LinkedIn
- Cover gradient + avatar inisial
- Tombol Connect (toggle) & Pesan
- Edit Profil via bottom sheet
- Section: Tentang, Pendidikan, Keahlian

### Navigasi (Soal 2)
- `salomon_bottom_bar` dengan 2 tab
- Animasi smooth antar halaman

## Dependencies
```yaml
salomon_bottom_bar: ^3.3.2
```

## Cara Menjalankan
```bash
flutter pub get
flutter run
```
