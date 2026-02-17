import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/simple_chart_widget.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  var isLoading = true.obs;
  var totalStudents = 0.obs;
  var totalTeachers = 0.obs;
  var totalStaff = 0.obs;
  var totalRevenue = 0.0.obs;
  var monthlyRevenue = <String, double>{}.obs;
  var transactionTypes = <String, int>{}.obs;
  var inventoryItems = 0.obs;
  var lowStockItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      
      // Simulate loading data from database
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual database queries
      totalStudents.value = 245;
      totalTeachers.value = 25;
      totalStaff.value = 12;
      totalRevenue.value = 125000000;
      inventoryItems.value = 156;
      lowStockItems.value = 8;
      
      // Monthly revenue data
      monthlyRevenue.value = {
        'Jan': 15000000,
        'Feb': 18000000,
        'Mar': 22000000,
        'Apr': 19000000,
        'May': 21000000,
        'Jun': 30000000,
      };
      
      // Transaction types
      transactionTypes.value = {
        'SPP': 180,
        'Iuran': 45,
        'Zakat': 23,
        'Infak': 67,
        'Tabungan': 89,
      };
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data dashboard: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    loadDashboardData();
  }

  String get userName => _authService.currentUser?.name ?? 'Admin';
  String get userRole => _authService.currentUser?.role ?? 'admin';
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Get.find<AuthService>().logout();
                Get.offAllNamed('/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                _buildWelcomeSection(controller),
                const SizedBox(height: 24),
                
                // Statistics Cards
                _buildStatisticsCards(controller),
                const SizedBox(height: 24),
                
                // Charts Section
                _buildChartsSection(controller),
                const SizedBox(height: 24),
                
                // Recent Activities
                _buildRecentActivities(),
                const SizedBox(height: 24),
                
                // Quick Actions
                _buildQuickActions(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWelcomeSection(DashboardController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConfig.islamicGreen,
            AppConfig.islamicBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mosque,
                color: AppConfig.islamicGold,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, ${controller.userName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sistem Tata Usaha Sekolah Islam',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Role: ${controller.userRole.toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(DashboardController controller) {
    return Column(
      children: [
        const Text(
          'Statistik Sekolah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'Total Siswa',
              controller.totalStudents.value.toString(),
              Icons.school,
              AppConfig.primaryColor,
            ),
            _buildStatCard(
              'Total Guru',
              controller.totalTeachers.value.toString(),
              Icons.person,
              AppConfig.secondaryColor,
            ),
            _buildStatCard(
              'Total Staf',
              controller.totalStaff.value.toString(),
              Icons.people,
              AppConfig.warningColor,
            ),
            _buildStatCard(
              'Total Inventaris',
              controller.inventoryItems.value.toString(),
              Icons.inventory,
              AppConfig.infoColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(DashboardController controller) {
    return Column(
      children: [
        const Text(
          'Grafik Keuangan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Monthly Revenue Chart
        CustomCard(
          title: 'Pendapatan Bulanan',
          child: SizedBox(
            height: 200,
            child: SimpleBarChart(
              data: controller.monthlyRevenue,
              color: AppConfig.primaryColor,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Transaction Types Chart
        CustomCard(
          title: 'Jenis Transaksi',
          child: SizedBox(
            height: 200,
            child: SimplePieChart(
              data: controller.transactionTypes,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      children: [
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        CustomCard(
          child: Column(
            children: [
              _buildActivityItem(
                Icons.payment,
                'Pembayaran SPP',
                'Ahmad Rizki - Kelas 12 IPA',
                '2 jam yang lalu',
                AppConfig.successColor,
              ),
              _buildActivityItem(
                Icons.person_add,
                'Siswa Baru',
                'Sarah Putri - Kelas 7',
                '5 jam yang lalu',
                AppConfig.infoColor,
              ),
              _buildActivityItem(
                Icons.inventory,
                'Inventaris Baru',
                'Proyektor - Ruang Kelas 5',
                '1 hari yang lalu',
                AppConfig.warningColor,
              ),
              _buildActivityItem(
                Icons.savings,
                'Tabungan',
                'Muhammad Fajar - Menabung Rp 50.000',
                '1 hari yang lalu',
                AppConfig.secondaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle, String time, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
          children: [
            _buildQuickAction(
              Icons.person_add,
              'Tambah Siswa',
              () => Get.toNamed('/students/add'),
              AppConfig.primaryColor,
            ),
            _buildQuickAction(
              Icons.payment,
              'Pembayaran',
              () => Get.toNamed('/finance/payment'),
              AppConfig.successColor,
            ),
            _buildQuickAction(
              Icons.inventory,
              'Inventaris',
              () => Get.toNamed('/inventory'),
              AppConfig.warningColor,
            ),
            _buildQuickAction(
              Icons.assessment,
              'Laporan',
              () => Get.toNamed('/reports'),
              AppConfig.infoColor,
            ),
            _buildQuickAction(
              Icons.backup,
              'Backup',
              () => Get.toNamed('/backup'),
              AppConfig.secondaryColor,
            ),
            _buildQuickAction(
              Icons.settings,
              'Pengaturan',
              () => Get.toNamed('/settings'),
              Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}