# What this app?
Aplikasi dengan tema 'Story App'. Aplikasi ini menampilkan dan mengunggah momen menarik saat Anda belajar. Anda bisa memanfaatkan beberapa materi yang telah dipelajari. 

## ARCHITECTURE

When running app always using `fvm` command

State Management: Provider
Network: http
Loading animation: Shimmer

## RULE
- Semua inisiasi harus berada di dalam file app.dart
- Menuliskan kode dengan bersih.
  - Bersihkan comment dan kode yang tidak digunakan.
  - Indentasi yang sesuai.
  - Menghapus import yang tidak digunakan.
- Menerapkan tampilan aplikasi yang sesuai standar.
  - Menerapkan tampilan aplikasi yang sesuai panduan desain sistem Material, Cupertino, Fluent, macOS, maupun Yaru.
  - Tidak ada komponen yang saling bertumpuk.
  - Penggunaan komponen yang sesuai dengan fungsinya.
- Menambahkan informasi selama proses interaksi dengan API, seperti
  - indikator loading ketika memuat data;
  - informasi error ketika gagal; dan pesan informasi ketika tidak ada data. 


## FOLDER STRUCTURE

lib/
├── core/
│   ├── api_client.dart
│   ├── app.dart
│   ├── app_route.dart
│   └── config.dart
├── features/
│   ├── home/
│   │   ├── providers/
│   │   │   ├── story_detail/
│   │   │   │   └── story_detail_provider.dart
│   │   │   └── story_list/
│   │   │       └── story_list_provider.dart
│   │   ├── screens/
│   │   │   ├── home_detail_screen.dart
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       └── story_card.dart
│   └── setting/
│       └── screens/
│           └── setting_screen.dart
├── shared/
│   ├── model/
│   │   ├── user.dart
│   └── widgets/
│       └── story_bottom_navigation.dart
└── main.dart

## API Spec

see API.md files in root projects.

## Detailed Feature

Phase 1:
1. Halaman Autentikasi
- Menampilkan halaman login untuk masuk ke dalam aplikasi.
- Membuat halaman register untuk mendaftarkan diri dalam aplikasi.
- Karakter password pada halaman autentikasi wajib disembunyikan.
- Menyimpan data sesi dan token di preferences. Data sesi ini berguna untuk mengatur alur aplikasi, seperti
  - Jika sudah login, pengguna langsung masuk ke halaman utama; dan 
  - Jika belum, pengguna diarahkan ke halaman login.
- Menyediakan fitur logout pada halaman utama. Tujuannya adalah menghapus informasi token dan sesi.

2. Halaman Cerita
- Menampilkan daftar cerita dari API yang disediakan. Informasi yang tersedia pada halaman ini adalah nama user dan foto.
- Menyediakan halaman detail ketika salah satu item cerita ditekan. Informasi yang tersedia pada halaman ini adalah nama user, foto, dan deskripsi.

3. Tambah Cerita
- Membuat halaman untuk menambahkan cerita baru.
- Berikan deskripsi singkat terkait dengan gambar saat menambahkan cerita baru.

4. Menerapkan Advanced Navigation
- Seluruh proses navigasi menerapkan declarative navigation.

5. Setelah mengunggah cerita, aplikasi beralih menampilkan halaman utama dan menampilkan item baru di daftar cerita paling atas (refresh).

6. Terdapat pengaturan untuk localization (multi bahasa). Bahasa Indonesia, Jepang, dan Inggris.