import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../config/app_config.dart';
import '../models/student.dart';
import '../services/database_service.dart';
import '../widgets/custom_widgets.dart';

class StudentController extends GetxController {
  final DatabaseService _dbService = DatabaseService.instance;
  
  var students = <Student>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedClass = ''.obs;
  var selectedStatus = ''.obs;
  
  // Form controllers
  final nisController = TextEditingController();
  final nisnController = TextEditingController();
  final nameController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final parentNameController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentAddressController = TextEditingController();
  
  var selectedGender = ''.obs;
  var selectedReligion = ''.obs;
  var selectedClassId = Rxn<int>();
  var photoPath = ''.obs;
  
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  @override
  void onClose() {
    // Dispose controllers
    nisController.dispose();
    nisnController.dispose();
    nameController.dispose();
    placeOfBirthController.dispose();
    dateOfBirthController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    parentNameController.dispose();
    parentPhoneController.dispose();
    parentAddressController.dispose();
    super.onClose();
  }

  Future<void> loadStudents() async {
    try {
      isLoading.value = true;
      
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('students');
      
      students.value = maps.map((map) => Student.fromJson(map)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data siswa: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStudent() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final db = await _dbService.database;
      
      Map<String, dynamic> studentData = {
        'nis': nisController.text,
        'nisn': nisnController.text.isEmpty ? null : nisnController.text,
        'name': nameController.text,
        'place_of_birth': placeOfBirthController.text.isEmpty ? null : placeOfBirthController.text,
        'date_of_birth': dateOfBirthController.text.isEmpty ? null : dateOfBirthController.text,
        'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
        'religion': selectedReligion.value.isEmpty ? null : selectedReligion.value,
        'address': addressController.text.isEmpty ? null : addressController.text,
        'phone': phoneController.text.isEmpty ? null : phoneController.text,
        'email': emailController.text.isEmpty ? null : emailController.text,
        'class_id': selectedClassId.value,
        'parent_name': parentNameController.text.isEmpty ? null : parentNameController.text,
        'parent_phone': parentPhoneController.text.isEmpty ? null : parentPhoneController.text,
        'parent_address': parentAddressController.text.isEmpty ? null : parentAddressController.text,
        'photo': photoPath.value.isEmpty ? null : photoPath.value,
        'registration_date': DateTime.now().toIso8601String(),
        'status': 'active',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await db.insert('students', studentData);
      
      Get.snackbar(
        'Berhasil',
        'Data siswa berhasil ditambahkan',
        backgroundColor: AppConfig.successColor,
        colorText: Colors.white,
      );
      
      clearForm();
      await loadStudents();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan siswa: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateStudent(Student student) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final db = await _dbService.database;
      
      Map<String, dynamic> studentData = {
        'nis': nisController.text,
        'nisn': nisnController.text.isEmpty ? null : nisnController.text,
        'name': nameController.text,
        'place_of_birth': placeOfBirthController.text.isEmpty ? null : placeOfBirthController.text,
        'date_of_birth': dateOfBirthController.text.isEmpty ? null : dateOfBirthController.text,
        'gender': selectedGender.value.isEmpty ? null : selectedGender.value,
        'religion': selectedReligion.value.isEmpty ? null : selectedReligion.value,
        'address': addressController.text.isEmpty ? null : addressController.text,
        'phone': phoneController.text.isEmpty ? null : phoneController.text,
        'email': emailController.text.isEmpty ? null : emailController.text,
        'class_id': selectedClassId.value,
        'parent_name': parentNameController.text.isEmpty ? null : parentNameController.text,
        'parent_phone': parentPhoneController.text.isEmpty ? null : parentPhoneController.text,
        'parent_address': parentAddressController.text.isEmpty ? null : parentAddressController.text,
        'photo': photoPath.value.isEmpty ? null : photoPath.value,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await db.update(
        'students',
        studentData,
        where: 'id = ?',
        whereArgs: [student.id],
      );
      
      Get.snackbar(
        'Berhasil',
        'Data siswa berhasil diperbarui',
        backgroundColor: AppConfig.successColor,
        colorText: Colors.white,
      );
      
      clearForm();
      await loadStudents();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui siswa: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteStudent(Student student) async {
    try {
      bool? confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data siswa ${student.name}?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Hapus'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final db = await _dbService.database;
        await db.delete(
          'students',
          where: 'id = ?',
          whereArgs: [student.id],
        );
        
        Get.snackbar(
          'Berhasil',
          'Data siswa berhasil dihapus',
          backgroundColor: AppConfig.successColor,
          colorText: Colors.white,
        );
        
        await loadStudents();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus siswa: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void editStudent(Student student) {
    nisController.text = student.nis;
    nisnController.text = student.nisn ?? '';
    nameController.text = student.name;
    placeOfBirthController.text = student.placeOfBirth ?? '';
    dateOfBirthController.text = student.dateOfBirth?.toString().split(' ')[0] ?? '';
    addressController.text = student.address ?? '';
    phoneController.text = student.phone ?? '';
    emailController.text = student.email ?? '';
    parentNameController.text = student.parentName ?? '';
    parentPhoneController.text = student.parentPhone ?? '';
    parentAddressController.text = student.parentAddress ?? '';
    selectedGender.value = student.gender ?? '';
    selectedReligion.value = student.religion ?? '';
    selectedClassId.value = student.classId;
    photoPath.value = student.photo ?? '';
    
    Get.to(() => StudentFormScreen(isEdit: true, student: student));
  }

  void clearForm() {
    nisController.clear();
    nisnController.clear();
    nameController.clear();
    placeOfBirthController.clear();
    dateOfBirthController.clear();
    addressController.clear();
    phoneController.clear();
    emailController.clear();
    parentNameController.clear();
    parentPhoneController.clear();
    parentAddressController.clear();
    selectedGender.value = '';
    selectedReligion.value = '';
    selectedClassId.value = null;
    photoPath.value = '';
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        photoPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (photo != null) {
        photoPath.value = photo.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil foto: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  List<Student> get filteredStudents {
    List<Student> filtered = students.where((student) {
      bool matchesSearch = student.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                          student.nis.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      bool matchesClass = selectedClass.value.isEmpty || student.classId.toString() == selectedClass.value;
      bool matchesStatus = selectedStatus.value.isEmpty || student.status == selectedStatus.value;
      
      return matchesSearch && matchesClass && matchesStatus;
    }).toList();
    
    return filtered;
  }

  Future<void> exportToExcel() async {
    try {
      Get.snackbar(
        'Info',
        'Export ke Excel akan segera tersedia',
        backgroundColor: AppConfig.infoColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal export data: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> exportToCSV() async {
    try {
      Get.snackbar(
        'Info',
        'Export ke CSV akan segera tersedia',
        backgroundColor: AppConfig.infoColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal export data: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    }
  }

  // Validation methods
  String? validateNIS(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIS harus diisi';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty && !RegExp(AppConfig.emailPattern).hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    return null;
  }
}

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Data Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const StudentFormScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _showExportDialog(controller),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          _buildSearchAndFilter(controller),
          
          // Student List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget(message: 'Memuat data siswa...');
              }
              
              if (controller.filteredStudents.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.school,
                  title: 'Tidak ada data siswa',
                  subtitle: 'Tambahkan siswa baru untuk memulai',
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredStudents.length,
                itemBuilder: (context, index) {
                  Student student = controller.filteredStudents[index];
                  return _buildStudentCard(student, controller);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(StudentController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          CustomTextField(
            hint: 'Cari siswa...',
            controller: TextEditingController(text: controller.searchQuery.value),
            prefixIcon: const Icon(Icons.search),
            onChanged: (value) => controller.searchQuery.value = value,
          ),
          
          const SizedBox(height: 16),
          
          // Filters
          Row(
            children: [
              Expanded(
                child: Obx(() => CustomDropdown<String>(
                  label: 'Kelas',
                  value: controller.selectedClass.value.isEmpty ? null : controller.selectedClass.value,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Semua')),
                    DropdownMenuItem(value: '1', child: Text('Kelas 1')),
                    DropdownMenuItem(value: '2', child: Text('Kelas 2')),
                    DropdownMenuItem(value: '3', child: Text('Kelas 3')),
                  ],
                  onChanged: (value) => controller.selectedClass.value = value ?? '',
                )),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Obx(() => CustomDropdown<String>(
                  label: 'Status',
                  value: controller.selectedStatus.value.isEmpty ? null : controller.selectedStatus.value,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Semua')),
                    DropdownMenuItem(value: 'active', child: Text('Aktif')),
                    DropdownMenuItem(value: 'inactive', child: Text('Tidak Aktif')),
                    DropdownMenuItem(value: 'graduated', child: Text('Lulus')),
                  ],
                  onChanged: (value) => controller.selectedStatus.value = value ?? '',
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Student student, StudentController controller) {
    return CustomCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
          backgroundImage: student.photo != null ? FileImage(File(student.photo!)) : null,
          child: student.photo == null
              ? Icon(
                  Icons.person,
                  color: AppConfig.primaryColor,
                  size: 30,
                )
              : null,
        ),
        title: Text(
          student.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIS: ${student.nis}'),
            if (student.nisn != null) Text('NISN: ${student.nisn}'),
            if (student.phone != null) Text('Telepon: ${student.phone}'),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(student.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student.displayStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (student.gender != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      student.displayGender,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'edit':
                controller.editStudent(student);
                break;
              case 'delete':
                controller.deleteStudent(student);
                break;
              case 'view':
                Get.to(() => StudentDetailScreen(student: student));
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Detail'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete),
                  SizedBox(width: 8),
                  Text('Hapus'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return AppConfig.successColor;
      case 'inactive':
        return AppConfig.warningColor;
      case 'graduated':
        return AppConfig.infoColor;
      default:
        return Colors.grey;
    }
  }

  void _showExportDialog(StudentController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Export Data Siswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pilih format export:'),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Export ke Excel',
              onPressed: () {
                Get.back();
                controller.exportToExcel();
              },
              icon: Icons.file_present,
              width: double.infinity,
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Export ke CSV',
              onPressed: () {
                Get.back();
                controller.exportToCSV();
              },
              icon: Icons.description,
              width: double.infinity,
              isOutlined: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }
}

class StudentFormScreen extends StatelessWidget {
  final bool isEdit;
  final Student? student;
  
  const StudentFormScreen({
    Key? key,
    this.isEdit = false,
    this.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudentController>();
    
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Siswa' : 'Tambah Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (isEdit && student != null) {
                controller.updateStudent(student!);
              } else {
                controller.addStudent();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Section
              _buildPhotoSection(controller),
              
              const SizedBox(height: 24),
              
              // Basic Information
              _buildBasicInfo(controller),
              
              const SizedBox(height: 24),
              
              // Parent Information
              _buildParentInfo(controller),
              
              const SizedBox(height: 24),
              
              // Additional Information
              _buildAdditionalInfo(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(StudentController controller) {
    return CustomCard(
      title: 'Foto Siswa',
      child: Column(
        children: [
          Obx(() => Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(60),
              image: controller.photoPath.value.isNotEmpty
                  ? DecorationImage(
                      image: FileImage(File(controller.photoPath.value)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: controller.photoPath.value.isEmpty
                ? const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.grey,
                  )
                : null,
          )),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: 'Ambil Foto',
                onPressed: controller.takePhoto,
                icon: Icons.camera_alt,
                isOutlined: true,
              ),
              CustomButton(
                text: 'Pilih Foto',
                onPressed: controller.pickImage,
                icon: Icons.photo_library,
                isOutlined: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(StudentController controller) {
    return CustomCard(
      title: 'Data Dasar',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'NIS',
                  hint: 'Nomor Induk Siswa',
                  controller: controller.nisController,
                  validator: controller.validateNIS,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'NISN',
                  hint: 'Nomor Induk Siswa Nasional',
                  controller: controller.nisnController,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Nama Lengkap',
            hint: 'Masukkan nama lengkap',
            controller: controller.nameController,
            validator: controller.validateName,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Tempat Lahir',
                  hint: 'Tempat lahir',
                  controller: controller.placeOfBirthController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Tanggal Lahir',
                  hint: 'YYYY-MM-DD',
                  controller: controller.dateOfBirthController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.dateOfBirthController.text = pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Obx(() => CustomDropdown<String>(
                  label: 'Jenis Kelamin',
                  value: controller.selectedGender.value.isEmpty ? null : controller.selectedGender.value,
                  items: const [
                    DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'P', child: Text('Perempuan')),
                  ],
                  onChanged: (value) => controller.selectedGender.value = value ?? '',
                )),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => CustomDropdown<String>(
                  label: 'Agama',
                  value: controller.selectedReligion.value.isEmpty ? null : controller.selectedReligion.value,
                  items: const [
                    DropdownMenuItem(value: 'Islam', child: Text('Islam')),
                    DropdownMenuItem(value: 'Kristen', child: Text('Kristen')),
                    DropdownMenuItem(value: 'Katolik', child: Text('Katolik')),
                    DropdownMenuItem(value: 'Hindu', child: Text('Hindu')),
                    DropdownMenuItem(value: 'Buddha', child: Text('Buddha')),
                    DropdownMenuItem(value: 'Konghucu', child: Text('Konghucu')),
                  ],
                  onChanged: (value) => controller.selectedReligion.value = value ?? '',
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParentInfo(StudentController controller) {
    return CustomCard(
      title: 'Data Orang Tua',
      child: Column(
        children: [
          CustomTextField(
            label: 'Nama Orang Tua',
            hint: 'Nama orang tua/wali',
            controller: controller.parentNameController,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Telepon Orang Tua',
            hint: 'Nomor telepon orang tua',
            controller: controller.parentPhoneController,
            keyboardType: TextInputType.phone,
            validator: controller.validatePhone,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Alamat Orang Tua',
            hint: 'Alamat orang tua',
            controller: controller.parentAddressController,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(StudentController controller) {
    return CustomCard(
      title: 'Informasi Tambahan',
      child: Column(
        children: [
          CustomTextField(
            label: 'Alamat Siswa',
            hint: 'Alamat lengkap siswa',
            controller: controller.addressController,
            maxLines: 3,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Telepon Siswa',
            hint: 'Nomor telepon siswa',
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Email Siswa',
            hint: 'Email siswa',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmail,
          ),
        ],
      ),
    );
  }
}

class StudentDetailScreen extends StatelessWidget {
  final Student student;
  
  const StudentDetailScreen({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo and Basic Info
            _buildPhotoAndBasicInfo(),
            
            const SizedBox(height: 24),
            
            // Personal Information
            _buildPersonalInfo(),
            
            const SizedBox(height: 24),
            
            // Parent Information
            _buildParentInfo(),
            
            const SizedBox(height: 24),
            
            // Contact Information
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoAndBasicInfo() {
    return CustomCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
            backgroundImage: student.photo != null ? FileImage(File(student.photo!)) : null,
            child: student.photo == null
                ? Icon(
                    Icons.person,
                    color: AppConfig.primaryColor,
                    size: 50,
                  )
                : null,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('NIS: ${student.nis}'),
                if (student.nisn != null) Text('NISN: ${student.nisn}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppConfig.successColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        student.displayStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (student.gender != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          student.displayGender,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return CustomCard(
      title: 'Informasi Pribadi',
      child: Column(
        children: [
          _buildInfoRow('Tempat Lahir', student.placeOfBirth ?? '-'),
          _buildInfoRow('Tanggal Lahir', student.dateOfBirth?.toString().split(' ')[0] ?? '-'),
          _buildInfoRow('Agama', student.religion ?? '-'),
          _buildInfoRow('Tanggal Registrasi', student.registrationDate?.toString().split(' ')[0] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildParentInfo() {
    return CustomCard(
      title: 'Informasi Orang Tua',
      child: Column(
        children: [
          _buildInfoRow('Nama Orang Tua', student.parentName ?? '-'),
          _buildInfoRow('Telepon Orang Tua', student.parentPhone ?? '-'),
          _buildInfoRow('Alamat Orang Tua', student.parentAddress ?? '-'),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return CustomCard(
      title: 'Informasi Kontak',
      child: Column(
        children: [
          _buildInfoRow('Alamat', student.address ?? '-'),
          _buildInfoRow('Telepon', student.phone ?? '-'),
          _buildInfoRow('Email', student.email ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}