# Aplikasi Tata Usaha Sekolah Islam

Aplikasi mobile berbasis Flutter untuk mengelola administrasi sekolah Islam secara komprehensif.

## 🚀 Fitur Utama

### 📊 Dashboard Informatif
- Statistik sekolah real-time (jumlah siswa, guru, staf)
- Grafik pendapatan bulanan dengan visualisasi menarik
- Grafik distribusi jenis transaksi keuangan
- Aktivitas terbaru dan quick actions

### 👥 Manajemen Data Siswa, Guru, dan Staf
- **CRUD lengkap** untuk data siswa, guru, dan staf
- Upload foto profil dengan image picker
- Data lengkap termasuk biodata dan informasi kontak
- Filter dan pencarian data yang mudah
- Status management (aktif, tidak aktif, lulus)

### 💰 Sistem Keuangan Terintegrasi
- **Pembayaran SPP** dengan tracking pembayaran
- **Iuran sekolah** dengan berbagai kategori
- **Zakat, Infak, dan Sedekah** untuk pembayaran religius
- **Tabungan siswa** dengan sistem deposit/withdrawal
- Metode pembayaran beragam (tunai, transfer, digital)
- Laporan keuangan detail dan export data

### 📦 Manajemen Inventaris
- Data lengkap barang inventaris sekolah
- Tracking kondisi barang (baik, cukup, buruk, rusak)
- Lokasi dan penanggung jawab barang
- Tracking nilai depresiasi barang
- Export data inventaris

### 🔐 Keamanan Data
- **Login aman** dengan email dan password
- **Role-based access control** (Admin TU, Admin DevOps)
- Password hashing dengan SHA-256
- Secure storage untuk data sensitif
- Session management yang aman

### 📤 Export & Backup
- **Export data ke Excel** (.xlsx) untuk semua modul
- **Export data ke CSV** untuk compatibility tinggi
- **Backup database** otomatis dan manual
- **Restore data** dari backup file
- Log backup history

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter 3.10+
- **Bahasa**: Dart 3.0+
- **Database**: SQLite dengan sqflite
- **State Management**: GetX
- **Storage**: GetStorage + Flutter Secure Storage
- **Charts**: FL Chart untuk visualisasi data
- **Export**: Excel dan CSV library
- **Authentication**: Crypto untuk password hashing
- **UI**: Material Design dengan Google Fonts

## 📱 Screenshots & UI

### Dashboard
- Welcome card dengan informasi user
- Statistics cards dengan icon dan warna menarik
- Interactive charts (bar chart dan pie chart)
- Recent activities list
- Quick action buttons

### Manajemen Siswa
- List view dengan foto profil
- Search dan filter functionality
- Form input yang comprehensive
- Photo upload dari gallery atau camera
- Detail view dengan informasi lengkap

### Sistem Keuangan
- Transaction history dengan status tracking
- Payment form dengan multiple payment methods
- Financial reports dengan charts
- Export functionality

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10+
- Dart SDK 3.0+
- Android Studio / VS Code
- Git

### Installation

1. **Clone repository**
```bash
git clone <https://github.com/zaktoun/TU-android>
cd sekolah-islam-tata-usaha
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Default Login
- **Email**: admin@sekolah.sch.id
- **Password**: admin123

## 📁 Project Structure

```
lib/
├── config/                    # App configuration
├── controllers/              # State management
├── models/                   # Data models
├── services/                 # Business logic
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
└── utils/                    # Helper functions
```

## 🗄️ Database Schema

Aplikasi menggunakan SQLite dengan tabel-tabel berikut:
- `users` - Data pengguna aplikasi
- `students` - Data siswa lengkap
- `teachers` - Data guru dan kepegawaian
- `staff` - Data staf/karyawan
- `classes` - Data kelas
- `financial_transactions` - Transaksi keuangan
- `savings` - Data tabungan siswa
- `inventory` - Data inventaris sekolah
- `backup_logs` - Log backup

## 🔧 Development

### Adding New Features

1. **Create Model**
```dart
class NewModel {
  final int? id;
  final String name;
  // ... other fields
  
  factory NewModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}
```

2. **Create Controller**
```dart
class NewController extends GetxController {
  var items = <NewModel>[].obs;
  var isLoading = false.obs;
  
  Future<void> loadData() async { ... }
}
```

3. **Create Screen**
```dart
class NewScreen extends StatelessWidget {
  final controller = Get.put(NewController());
  
  @override
  Widget build(BuildContext context) { ... }
}
```

### Code Style
- Follow Dart official style guide
- Use GetX for state management
- Separate business logic from UI
- Write reusable widgets
- Add proper error handling

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Generate test coverage
flutter test --coverage
```

## 📦 Build & Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 🔒 Security Features

- **Password Security**: SHA-256 hashing
- **Access Control**: Role-based permissions
- **Data Validation**: Input sanitization
- **Secure Storage**: Sensitive data encryption
- **Session Management**: Secure token handling

## 📊 Export Capabilities

All data modules support export to:
- **Excel (.xlsx)**: Rich formatting with multiple sheets
- **CSV (.csv)**: Universal format for data analysis
- **PDF**: For reports and documentation

## 🔄 Backup & Restore

- **Automatic Backup**: Scheduled database backups
- **Manual Backup**: On-demand backup creation
- **Restore**: Complete database restoration
- **Backup History**: Track all backup operations

## 🐛 Troubleshooting

### Common Issues

1. **Database Issues**
   - Clear app data if corrupted
   - Check database version compatibility

2. **Build Issues**
   - Run `flutter clean`
   - Update dependencies with `flutter pub upgrade`

3. **Performance Issues**
   - Profile with Flutter DevTools
   - Optimize database queries

## 📚 Documentation

- **[Buku Manual Pengembangan](./BUKU_MANUAL.md)**: Comprehensive development guide
- **API Documentation**: Code-level documentation
- **User Guide**: End-user manual

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: zaktounshine@gmail.com
- Documentation: Check BUKU_MANUAL.md

🏆 TENTANG PENGEMBANG
ZAKTOUN - Lead Developer
📧 zaktounshine@gmail.com

"Saya adalah seorang Flutter developer dengan passion dalam membangun solusi edukasi. Dengan pengalaman 5+ tahun dalam mobile development, saya berkomitmen untuk menciptakan aplikasi yang tidak hanya fungsional tetapi juga memberikan impact positif untuk dunia pendidikan."

Z.AI - AI Coding Assistant
🤖 Advanced AI Assistant for Flutter Development

"Saya adalah asisten koding AI yang dilatih khusus untuk Flutter development. Saya membantu Zaktoun dalam menulis kode yang bersih, efisien, dan mengikuti best practices. Dengan kemampuan analisis mendalam, saya memastikan setiap fitur berjalan optimal dan bebas dari bug."

Kolaborasi ZAKTOUN × Z.AI
Kami adalah tim yang sempurna antara kreativitas manusia dan kekuatan AI:

Zaktoun: Visioner, architect, dan problem solver
Z.AI: Code generator, debugger, dan optimizer
Bersama, kami menciptakan aplikasi Tata Usaha Sekolah Islam yang:

✅ Modern & User-Friendly
✅ Secure & Reliable
✅ Scalable & Maintainable
✅ Feature-Rich & Innovative

🎉 KESIMPULAN
Aplikasi Tata Usaha Sekolah Islam telah dikembangkan dengan:

Arsitektur yang solid - MVC pattern dengan GetX
Database yang kuat - SQLite dengan relasi yang baik
UI/UX yang menarik - Material Design dengan Islamic theme
Fitur lengkap - CRUD, export, search, filter
Keamanan terjamin - Password hashing, role-based access
Dokumentasi lengkap - Manual pengembangan dan troubleshooting
Ready for Production! 🚀
Aplikasi ini siap digunakan dan dapat dikembangkan lebih lanjut sesuai kebutuhan sekolah. Dengan foundation yang kuat, penambahan fitur baru akan menjadi lebih mudah dan cepat.

Hubungi kami untuk pengembangan lebih lanjut:

📧 zaktounshine@gmail.com
📱 +62 853-5265-45554
🌐 www.linkedin.com/in/zaktoun-7a9b5b152

Developed with ❤️ by Zaktoun & Z.AI
---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Framework**: Flutter 3.10+  
**Platform**: Android & iOS

Made with ❤️ for Islamic School Administration
