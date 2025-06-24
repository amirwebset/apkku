# 📱 Aplikasi Jadwal Sholat Flutter

Aplikasi Flutter sederhana yang menampilkan **jadwal sholat harian** berdasarkan kota di Indonesia. Aplikasi ini terdiri dari **tiga halaman utama** yang saling terhubung menggunakan **navigasi tombol/tab**.

---

## ✨ Fitur Utama

- Menampilkan **jadwal sholat otomatis** berdasarkan kota tetap (contoh: Pamekasan).
- Navigasi antar halaman menggunakan **`BottomNavigationBar`**.
- Mengambil data waktu sholat langsung dari **API publik Aladhan**.
- Desain sederhana dan mudah digunakan.

---

## 📂 Struktur Halaman

| Halaman | Nama File     | Fungsi                                                                 |
|--------|---------------|------------------------------------------------------------------------|
| 1️⃣ Beranda | `kota.dart`     | Menampilkan jadwal sholat kota **Pamekasan** secara langsung (tanpa input).  |
| 2️⃣ Cari Kota | `search.dart`   | Menampilkan jadwal sholat berdasarkan kota yang dicari secara manual.       |
| 3️⃣ Tentang   | `about.dart`    | Menampilkan informasi tentang aplikasi.                                     |

---

## 🔄 Navigasi Halaman

Navigasi dilakukan dengan **BottomNavigationBar**, contoh potongan kode:

```dart
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'),
  ],
),
