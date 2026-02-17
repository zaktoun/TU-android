# Buku Manual Pengembangan Aplikasi Tata Usaha Sekolah Islam

## Daftar Isi

1. [Pendahuluan](#pendahuluan)
2. [Arsitektur Aplikasi](#arsitektur-aplikasi)
3. [Instalasi dan Setup](#instalasi-dan-setup)
4. [Struktur Proyek](#struktur-proyek)
5. [Database Schema](#database-schema)
6. [Fitur-fitur Aplikasi](#fitur-fitur-aplikasi)
7. [Panduan Pengembangan](#panduan-pengembangan)
8. [Security Best Practices](#security-best-practices)
9. [Testing](#testing)
10. [Deployment](#deployment)
11. [Troubleshooting](#troubleshooting)
12. [Appendix](#appendix)

## Pendahuluan

Aplikasi Tata Usaha Sekolah Islam adalah aplikasi mobile berbasis Flutter yang dirancang khusus untuk mengelola administrasi sekolah Islam secara komprehensif. Aplikasi ini mencakup manajemen siswa, guru, staf, keuangan, inventaris, dan laporan.

### Fitur Utama:
- Manajemen data siswa, guru, dan staf dengan foto
- Sistem keuangan (SPP, iuran, zakat, infak, sedekah, tabungan)
- Manajemen inventaris sekolah
- Dashboard dengan grafis informatif
- Export data ke Excel/CSV
- Backup dan restore data
- Login aman dengan role-based access

### Teknologi yang Digunakan:
- **Framework**: Flutter 3.10+
- **Bahasa**: Dart 3.0+
- **Database**: SQLite (sqflite)
- **State Management**: GetX
- **Storage**: GetStorage + Flutter Secure Storage
- **Charts**: FL Chart
- **Export**: Excel, CSV
- **Authentication**: Crypto untuk hashing password

## Arsitektur Aplikasi

### Pattern yang Digunakan:
- **MVC (Model-View-Controller)**: Untuk struktur aplikasi
- **Service Layer**: Untuk business logic
- **Repository Pattern**: Untuk data access

### Komponen Utama:
1. **Models**: Mendefinisikan struktur data
2. **Controllers**: Mengelola state dan business logic
3. **Services**: Menangani operasi database dan eksternal
4. **Views**: UI components dan screens
5. **Widgets**: Reusable UI components
6. **Utils**: Helper functions dan utilities

## Instalasi dan Setup

### Prerequisites:
- Flutter SDK 3.10 atau lebih tinggi
- Dart SDK 3.0 atau lebih tinggi
- Android Studio / VS Code
- Git

### Langkah Instalasi:

1. **Clone Repository:**
```bash
git clone <git clone <https://github.com/zaktoun/TU-android>
cd sekolah-islam-tata-usaha
```

2. **Install Dependencies:**
```bash
flutter pub get
```

3. **Run Application:**
```bash
flutter run
```

4. **Build for Production:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Environment Setup:
- Tidak memerlukan environment variables khusus
- Database SQLite otomatis dibuat saat pertama kali dijalankan
- File storage menggunakan direktori default aplikasi

## Struktur Proyek

```
lib/
├── config/
│   └── app_config.dart          # Konfigurasi aplikasi
├── controllers/
│   ├── dashboard_controller.dart
│   ├── login_controller.dart
│   └── student_controller.dart
├── models/
│   ├── user.dart
│   ├── student.dart
│   ├── teacher.dart
│   ├── staff.dart
│   ├── financial_transaction.dart
│   └── inventory.dart
├── services/
│   ├── auth_service.dart        # Authentication service
│   ├── database_service.dart   # Database operations
│   └── export_service.dart     # Export functionality
├── screens/
│   ├── dashboard_screen.dart
│   ├── login_screen.dart
│   └── student_screen.dart
├── widgets/
│   ├── custom_widgets.dart     # Custom UI components
│   └── chart_widget.dart       # Chart components
├── utils/
│   └── helpers.dart            # Utility functions
└── main.dart                   # Entry point
```

### Assets Structure:
```
assets/
├── images/                     # Image assets
├── icons/                      # Icon assets
├── animations/                 # Lottie animations
└── fonts/                      # Custom fonts
```

## Database Schema

### Tables:

1. **users**: Data pengguna aplikasi
2. **students**: Data siswa
3. **teachers**: Data guru
4. **staff**: Data staf/karyawan
5. **classes**: Data kelas
6. **financial_transactions**: Transaksi keuangan
7. **savings**: Data tabungan siswa
8. **inventory**: Data inventaris sekolah
9. **backup_logs**: Log backup

### Schema Details:

#### users
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin_tu', 'admin_devops')),
    photo TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);
```

#### students
```sql
CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nis TEXT UNIQUE NOT NULL,
    nisn TEXT UNIQUE,
    name TEXT NOT NULL,
    place_of_birth TEXT,
    date_of_birth TEXT,
    gender TEXT CHECK (gender IN ('L', 'P')),
    religion TEXT,
    address TEXT,
    phone TEXT,
    email TEXT,
    class_id INTEGER,
    parent_name TEXT,
    parent_phone TEXT,
    parent_address TEXT,
    photo TEXT,
    registration_date TEXT NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'graduated')),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes (id)
);
```

## Fitur-fitur Aplikasi

### 1. Authentication System
- Login dengan email dan password
- Role-based access control (Admin TU, Admin DevOps)
- Password hashing dengan SHA-256
- Session management dengan secure storage

### 2. Dashboard
- Statistik sekolah (jumlah siswa, guru, staf)
- Grafik pendapatan bulanan
- Grafik jenis transaksi
- Aktivitas terbaru
- Quick actions

### 3. Manajemen Siswa
- CRUD data siswa
- Upload foto siswa
- Filter dan pencarian
- Export data ke Excel/CSV
- Detail siswa lengkap

### 4. Manajemen Guru
- CRUD data guru
- Data kepegawaian
- Spesialisasi mengajar
- Export data

### 5. Manajemen Staf
- CRUD data staf
- Informasi jabatan
- Status kepegawaian

### 6. Sistem Keuangan
- Pembayaran SPP
- Iuran sekolah
- Zakat, infak, sedekah
- Tabungan siswa
- Laporan keuangan
- Export transaksi

### 7. Inventaris
- Data barang inventaris
- Tracking kondisi barang
- Lokasi penyimpanan
- Penanggung jawab
- Export data inventaris

### 8. Backup & Restore
- Backup database otomatis
- Restore dari backup
- Log backup history

## Panduan Pengembangan

### Menambah Fitur Baru:

1. **Buat Model:**
```dart
class NewModel {
  final int? id;
  final String name;
  final DateTime createdAt;
  
  NewModel({
    this.id,
    required this.name,
    required this.createdAt,
  });
  
  factory NewModel.fromJson(Map<String, dynamic> json) {
    return NewModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

2. **Buat Controller:**
```dart
class NewController extends GetxController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  var items = <NewModel>[].obs;
  var isLoading = false.obs;
  
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('new_table');
      items.value = maps.map((map) => NewModel.fromJson(map)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
```

3. **Buat Screen:**
```dart
class NewScreen extends StatelessWidget {
  final controller = Get.put(NewController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Feature')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index) {
            final item = controller.items[index];
            return ListTile(title: Text(item.name));
          },
        );
      }),
    );
  }
}
```

### Best Practices:

1. **Code Organization:**
   - Gunakan pattern yang konsisten
   - Pisahkan business logic dari UI
   - Reuse widgets wherever possible

2. **Error Handling:**
   - Gunakan try-catch untuk async operations
   - Tampilkan user-friendly error messages
   - Log errors untuk debugging

3. **Performance:**
   - Gunakan Obx() hanya untuk reactive variables
   - Hindari unnecessary rebuilds
   - Optimize image sizes

4. **Security:**
   - Validate input data
   - Use secure storage for sensitive data
   - Implement proper authentication

## Security Best Practices

### 1. Password Security:
- Hash passwords dengan SHA-256
- Implement password strength validation
- Use secure storage for tokens

### 2. Data Validation:
- Validate all input data
- Sanitize user inputs
- Use parameterized queries

### 3. Access Control:
- Implement role-based access
- Check permissions before operations
- Log user activities

### 4. Data Protection:
- Encrypt sensitive data
- Use secure storage APIs
- Implement proper session management

## Testing

### Unit Testing:
```bash
flutter test
```

### Integration Testing:
```bash
flutter test integration_test/
```

### Widget Testing:
```bash
flutter test test/widget_tests/
```

### Test Coverage:
- Aim for >80% code coverage
- Test all critical business logic
- Test error scenarios

## Deployment

### Android:
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS:
```bash
# Build for iOS
flutter build ios --release

# Archive and distribute via Xcode
```

### Release Checklist:
- [ ] Update version number
- [ ] Test on real devices
- [ ] Check permissions
- [ ] Optimize app size
- [ ] Test backup/restore functionality
- [ ] Verify all exports work correctly

## Troubleshooting

### Common Issues:

1. **Database Issues:**
   - Clear app data if database corrupted
   - Check database version compatibility
   - Verify SQL syntax

2. **Performance Issues:**
   - Profile app with Flutter DevTools
   - Optimize database queries
   - Reduce widget rebuilds

3. **Build Issues:**
   - Clean build cache: `flutter clean`
   - Update dependencies: `flutter pub upgrade`
   - Check Flutter version compatibility

### Debug Mode:
```bash
flutter run --debug
flutter run --profile
```

### Logs:
```dart
// Enable logging
import 'package:logging/logging.dart';

final _logger = Logger('MyApp');
_logger.info('Debug message');
```

## Appendix

### Dependencies:
- `get`: State management
- `sqflite`: Database
- `get_storage`: Local storage
- `flutter_secure_storage`: Secure storage
- `excel`: Excel export
- `csv`: CSV export
- `fl_chart`: Charts
- `image_picker`: Image handling
- `file_picker`: File picker

### Configuration Files:
- `pubspec.yaml`: Dependencies and assets
- `android/app/build.gradle`: Android configuration
- `ios/Runner/Info.plist`: iOS configuration

### Useful Commands:
```bash
# Get dependencies
flutter pub get

# Clean build
flutter clean

# Run tests
flutter test

# Build APK
flutter build apk

# Analyze code
flutter analyze

# Format code
dart format .
```

### Support:
- Documentation: [Flutter Docs](https://flutter.dev/docs)
- Community: [Flutter Community](https://github.com/flutter/flutter)
- Issues: Create issue on repository

---

**Version**: 1.0.0  
**Last Updated**: 2024  
**Author**: Development Team  

Untuk pertanyaan atau dukungan lebih lanjut, silakan hubungi tim pengembangan.
