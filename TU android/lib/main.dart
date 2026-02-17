import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/app_config.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/student_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize services
  await Get.putAsync(() async => DatabaseService.instance);
  await Get.putAsync(() async => AuthService());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppConfig.lightTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          Get.theme.textTheme,
        ),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/students', page: () => const StudentListScreen()),
        GetPage(name: '/students/add', page: () => const StudentFormScreen()),
        GetPage(name: '/teachers', page: () => const TeacherListScreen()),
        GetPage(name: '/teachers/add', page: () => const TeacherFormScreen()),
        GetPage(name: '/staff', page: () => const StaffListScreen()),
        GetPage(name: '/staff/add', page: () => const StaffFormScreen()),
        GetPage(name: '/finance', page: () => const FinanceScreen()),
        GetPage(name: '/finance/payment', page: () => const PaymentScreen()),
        GetPage(name: '/inventory', page: () => const InventoryScreen()),
        GetPage(name: '/inventory/add', page: () => const InventoryFormScreen()),
        GetPage(name: '/reports', page: () => const ReportsScreen()),
        GetPage(name: '/backup', page: () => const BackupScreen()),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
      ],
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    
    return Obx(() {
      if (authService.isLoggedIn()) {
        return const DashboardScreen();
      } else {
        return const LoginScreen();
      }
    });
  }
}

// Placeholder screens for other routes
class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Guru')),
      body: const Center(
        child: Text('Data Guru - Coming Soon'),
      ),
    );
  }
}

class TeacherFormScreen extends StatelessWidget {
  const TeacherFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Guru')),
      body: const Center(
        child: Text('Form Guru - Coming Soon'),
      ),
    );
  }
}

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Staf')),
      body: const Center(
        child: Text('Data Staf - Coming Soon'),
      ),
    );
  }
}

class StaffFormScreen extends StatelessWidget {
  const StaffFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Staf')),
      body: const Center(
        child: Text('Form Staf - Coming Soon'),
      ),
    );
  }
}

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keuangan')),
      body: const Center(
        child: Text('Keuangan - Coming Soon'),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pembayaran')),
      body: const Center(
        child: Text('Pembayaran - Coming Soon'),
      ),
    );
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventaris')),
      body: const Center(
        child: Text('Inventaris - Coming Soon'),
      ),
    );
  }
}

class InventoryFormScreen extends StatelessWidget {
  const InventoryFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Inventaris')),
      body: const Center(
        child: Text('Form Inventaris - Coming Soon'),
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: const Center(
        child: Text('Laporan - Coming Soon'),
      ),
    );
  }
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: const Center(
        child: Text('Backup - Coming Soon'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: const Center(
        child: Text('Pengaturan - Coming Soon'),
      ),
    );
  }
}