import 'dart:io';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/staff.dart';
import '../models/financial_transaction.dart';
import '../models/inventory.dart';
import '../services/database_service.dart';
import '../config/app_config.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final DatabaseService _dbService = DatabaseService.instance;

  // Export Students to Excel
  Future<String> exportStudentsToExcel() async {
    try {
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('students');
      
      // Create Excel file
      var excel = Excel.createExcel();
      Sheet sheet = excel['Data Siswa'];
      
      // Add headers
      final headers = [
        'ID', 'NIS', 'NISN', 'Nama', 'Tempat Lahir', 'Tanggal Lahir',
        'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
        'Nama Orang Tua', 'Telepon Orang Tua', 'Alamat Orang Tua',
        'Status', 'Tanggal Registrasi'
      ];
      
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }
      
      // Add data
      for (int i = 0; i < maps.length; i++) {
        Map<String, dynamic> studentData = maps[i];
        int rowIndex = i + 1;
        
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = studentData['id'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = studentData['nis'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = studentData['nisn'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = studentData['name'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = studentData['place_of_birth'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = studentData['date_of_birth'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = studentData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = studentData['religion'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = studentData['address'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
            .value = studentData['phone'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
            .value = studentData['email'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
            .value = studentData['parent_name'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
            .value = studentData['parent_phone'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex))
            .value = studentData['parent_address'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex))
            .value = studentData['status'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex))
            .value = studentData['registration_date'];
      }
      
      // Save file
      String fileName = 'data_siswa_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.save()!);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export data siswa: $e');
    }
  }

  // Export Students to CSV
  Future<String> exportStudentsToCSV() async {
    try {
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('students');
      
      List<List<dynamic>> rows = [];
      
      // Add headers
      rows.add([
        'ID', 'NIS', 'NISN', 'Nama', 'Tempat Lahir', 'Tanggal Lahir',
        'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
        'Nama Orang Tua', 'Telepon Orang Tua', 'Alamat Orang Tua',
        'Status', 'Tanggal Registrasi'
      ]);
      
      // Add data
      for (var studentData in maps) {
        rows.add([
          studentData['id'],
          studentData['nis'],
          studentData['nisn'],
          studentData['name'],
          studentData['place_of_birth'],
          studentData['date_of_birth'],
          studentData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan',
          studentData['religion'],
          studentData['address'],
          studentData['phone'],
          studentData['email'],
          studentData['parent_name'],
          studentData['parent_phone'],
          studentData['parent_address'],
          studentData['status'],
          studentData['registration_date'],
        ]);
      }
      
      String csv = const ListToCsvConverter().convert(rows);
      
      // Save file
      String fileName = 'data_siswa_${DateTime.now().millisecondsSinceEpoch}.csv';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsString(csv);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export data siswa ke CSV: $e');
    }
  }

  // Export Teachers to Excel
  Future<String> exportTeachersToExcel() async {
    try {
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('teachers');
      
      var excel = Excel.createExcel();
      Sheet sheet = excel['Data Guru'];
      
      // Add headers
      final headers = [
        'ID', 'NIP', 'Nama', 'Tempat Lahir', 'Tanggal Lahir',
        'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
        'Spesialisasi', 'Status Kepegawaian', 'Tanggal Masuk'
      ];
      
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }
      
      // Add data
      for (int i = 0; i < maps.length; i++) {
        Map<String, dynamic> teacherData = maps[i];
        int rowIndex = i + 1;
        
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = teacherData['id'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = teacherData['nip'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = teacherData['name'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = teacherData['place_of_birth'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = teacherData['date_of_birth'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = teacherData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = teacherData['religion'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = teacherData['address'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = teacherData['phone'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
            .value = teacherData['email'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
            .value = teacherData['specialization'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
            .value = teacherData['employment_status'] == 'active' ? 'Aktif' : 'Tidak Aktif';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
            .value = teacherData['hire_date'];
      }
      
      // Save file
      String fileName = 'data_guru_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.save()!);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export data guru: $e');
    }
  }

  // Export Financial Transactions to Excel
  Future<String> exportFinancialTransactionsToExcel() async {
    try {
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('financial_transactions');
      
      var excel = Excel.createExcel();
      Sheet sheet = excel['Data Transaksi Keuangan'];
      
      // Add headers
      final headers = [
        'ID', 'Kode Transaksi', 'ID Siswa', 'Jenis Transaksi', 'Jumlah',
        'Deskripsi', 'Metode Pembayaran', 'Tanggal Pembayaran', 'Status',
        'Dibuat Oleh', 'Tanggal Dibuat'
      ];
      
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }
      
      // Add data
      for (int i = 0; i < maps.length; i++) {
        Map<String, dynamic> transactionData = maps[i];
        int rowIndex = i + 1;
        
        String displayType = '';
        switch (transactionData['type']) {
          case 'spp':
            displayType = 'SPP';
            break;
          case 'iuran':
            displayType = 'Iuran';
            break;
          case 'zakat':
            displayType = 'Zakat';
            break;
          case 'infak':
            displayType = 'Infak';
            break;
          case 'sedekah':
            displayType = 'Sedekah';
            break;
          case 'tabungan':
            displayType = 'Tabungan';
            break;
          default:
            displayType = 'Lainnya';
        }
        
        String displayStatus = '';
        switch (transactionData['status']) {
          case 'paid':
            displayStatus = 'Lunas';
            break;
          case 'pending':
            displayStatus = 'Pending';
            break;
          case 'cancelled':
            displayStatus = 'Dibatalkan';
            break;
          default:
            displayStatus = 'Tidak Diketahui';
        }
        
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = transactionData['id'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = transactionData['transaction_code'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = transactionData['student_id'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = displayType;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = transactionData['amount'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = transactionData['description'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = transactionData['payment_method'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = transactionData['payment_date'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = displayStatus;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
            .value = transactionData['created_by'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
            .value = transactionData['created_at'];
      }
      
      // Save file
      String fileName = 'data_transaksi_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.save()!);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export data transaksi: $e');
    }
  }

  // Export Inventory to Excel
  Future<String> exportInventoryToExcel() async {
    try {
      final db = await _dbService.database;
      List<Map<String, dynamic>> maps = await db.query('inventory');
      
      var excel = Excel.createExcel();
      Sheet sheet = excel['Data Inventaris'];
      
      // Add headers
      final headers = [
        'ID', 'Kode Barang', 'Nama Barang', 'Kategori', 'Deskripsi',
        'Jumlah', 'Satuan', 'Tanggal Pembelian', 'Harga Pembelian',
        'Nilai Sekarang', 'Kondisi', 'Lokasi', 'Penanggung Jawab'
      ];
      
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }
      
      // Add data
      for (int i = 0; i < maps.length; i++) {
        Map<String, dynamic> inventoryData = maps[i];
        int rowIndex = i + 1;
        
        String displayCondition = '';
        switch (inventoryData['condition_status']) {
          case 'good':
            displayCondition = 'Baik';
            break;
          case 'fair':
            displayCondition = 'Cukup';
            break;
          case 'poor':
            displayCondition = 'Buruk';
            break;
          case 'damaged':
            displayCondition = 'Rusak';
            break;
          default:
            displayCondition = 'Tidak Diketahui';
        }
        
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = inventoryData['id'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = inventoryData['item_code'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = inventoryData['name'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = inventoryData['category'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = inventoryData['description'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = inventoryData['quantity'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = inventoryData['unit'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = inventoryData['purchase_date'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = inventoryData['purchase_price'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
            .value = inventoryData['current_value'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
            .value = displayCondition;
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
            .value = inventoryData['location'];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
            .value = inventoryData['responsible_person'];
      }
      
      // Save file
      String fileName = 'data_inventaris_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.save()!);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export data inventaris: $e');
    }
  }

  // Export All Data to Excel
  Future<String> exportAllDataToExcel() async {
    try {
      var excel = Excel.createExcel();
      
      // Export Students
      await _addStudentSheet(excel);
      
      // Export Teachers
      await _addTeacherSheet(excel);
      
      // Export Staff
      await _addStaffSheet(excel);
      
      // Export Financial Transactions
      await _addFinancialTransactionSheet(excel);
      
      // Export Inventory
      await _addInventorySheet(excel);
      
      // Save file
      String fileName = 'data_lengkap_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      
      if (selectedDirectory != null) {
        String filePath = '$selectedDirectory/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(excel.save()!);
        return filePath;
      } else {
        throw Exception('Tidak ada direktori yang dipilih');
      }
    } catch (e) {
      throw Exception('Gagal export semua data: $e');
    }
  }

  Future<void> _addStudentSheet(Excel excel) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps = await db.query('students');
    
    Sheet sheet = excel['Data Siswa'];
    
    // Add headers and data (similar to exportStudentsToExcel method)
    final headers = [
      'ID', 'NIS', 'NISN', 'Nama', 'Tempat Lahir', 'Tanggal Lahir',
      'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
      'Nama Orang Tua', 'Telepon Orang Tua', 'Alamat Orang Tua',
      'Status', 'Tanggal Registrasi'
    ];
    
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
    
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> studentData = maps[i];
      int rowIndex = i + 1;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = studentData['id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = studentData['nis'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = studentData['nisn'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = studentData['name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = studentData['place_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = studentData['date_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = studentData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = studentData['religion'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
          .value = studentData['address'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
          .value = studentData['phone'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
          .value = studentData['email'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
          .value = studentData['parent_name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
          .value = studentData['parent_phone'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 13, rowIndex: rowIndex))
          .value = studentData['parent_address'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex))
          .value = studentData['status'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex))
          .value = studentData['registration_date'];
    }
  }

  Future<void> _addTeacherSheet(Excel excel) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps = await db.query('teachers');
    
    Sheet sheet = excel['Data Guru'];
    
    // Add headers and data (similar to exportTeachersToExcel method)
    final headers = [
      'ID', 'NIP', 'Nama', 'Tempat Lahir', 'Tanggal Lahir',
      'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
      'Spesialisasi', 'Status Kepegawaian', 'Tanggal Masuk'
    ];
    
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
    
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> teacherData = maps[i];
      int rowIndex = i + 1;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = teacherData['id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = teacherData['nip'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = teacherData['name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = teacherData['place_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = teacherData['date_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = teacherData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = teacherData['religion'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = teacherData['address'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
          .value = teacherData['phone'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
          .value = teacherData['email'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
          .value = teacherData['specialization'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
          .value = teacherData['employment_status'] == 'active' ? 'Aktif' : 'Tidak Aktif';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
          .value = teacherData['hire_date'];
    }
  }

  Future<void> _addStaffSheet(Excel excel) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps = await db.query('staff');
    
    Sheet sheet = excel['Data Staf'];
    
    // Add headers and data
    final headers = [
      'ID', 'NIK', 'Nama', 'Jabatan', 'Tempat Lahir', 'Tanggal Lahir',
      'Jenis Kelamin', 'Agama', 'Alamat', 'Telepon', 'Email',
      'Status Kepegawaian', 'Tanggal Masuk'
    ];
    
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
    
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> staffData = maps[i];
      int rowIndex = i + 1;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = staffData['id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = staffData['nik'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = staffData['name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = staffData['position'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = staffData['place_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = staffData['date_of_birth'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = staffData['gender'] == 'L' ? 'Laki-laki' : 'Perempuan';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = staffData['religion'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
          .value = staffData['address'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
          .value = staffData['phone'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
          .value = staffData['email'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
          .value = staffData['employment_status'] == 'active' ? 'Aktif' : 'Tidak Aktif';
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
          .value = staffData['hire_date'];
    }
  }

  Future<void> _addFinancialTransactionSheet(Excel excel) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps = await db.query('financial_transactions');
    
    Sheet sheet = excel['Data Transaksi Keuangan'];
    
    // Add headers and data (similar to exportFinancialTransactionsToExcel method)
    final headers = [
      'ID', 'Kode Transaksi', 'ID Siswa', 'Jenis Transaksi', 'Jumlah',
      'Deskripsi', 'Metode Pembayaran', 'Tanggal Pembayaran', 'Status',
      'Dibuat Oleh', 'Tanggal Dibuat'
    ];
    
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
    
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> transactionData = maps[i];
      int rowIndex = i + 1;
      
      String displayType = '';
      switch (transactionData['type']) {
        case 'spp':
          displayType = 'SPP';
          break;
        case 'iuran':
          displayType = 'Iuran';
          break;
        case 'zakat':
          displayType = 'Zakat';
          break;
        case 'infak':
          displayType = 'Infak';
          break;
        case 'sedekah':
          displayType = 'Sedekah';
          break;
        case 'tabungan':
          displayType = 'Tabungan';
          break;
        default:
          displayType = 'Lainnya';
      }
      
      String displayStatus = '';
      switch (transactionData['status']) {
        case 'paid':
          displayStatus = 'Lunas';
          break;
        case 'pending':
          displayStatus = 'Pending';
          break;
        case 'cancelled':
          displayStatus = 'Dibatalkan';
          break;
        default:
          displayStatus = 'Tidak Diketahui';
      }
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = transactionData['id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = transactionData['transaction_code'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = transactionData['student_id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = displayType;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = transactionData['amount'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = transactionData['description'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = transactionData['payment_method'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = transactionData['payment_date'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
          .value = displayStatus;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
          .value = transactionData['created_by'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
          .value = transactionData['created_at'];
    }
  }

  Future<void> _addInventorySheet(Excel excel) async {
    final db = await _dbService.database;
    List<Map<String, dynamic>> maps = await db.query('inventory');
    
    Sheet sheet = excel['Data Inventaris'];
    
    // Add headers and data (similar to exportInventoryToExcel method)
    final headers = [
      'ID', 'Kode Barang', 'Nama Barang', 'Kategori', 'Deskripsi',
      'Jumlah', 'Satuan', 'Tanggal Pembelian', 'Harga Pembelian',
      'Nilai Sekarang', 'Kondisi', 'Lokasi', 'Penanggung Jawab'
    ];
    
    for (int i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = headers[i];
    }
    
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> inventoryData = maps[i];
      int rowIndex = i + 1;
      
      String displayCondition = '';
      switch (inventoryData['condition_status']) {
        case 'good':
          displayCondition = 'Baik';
          break;
        case 'fair':
          displayCondition = 'Cukup';
          break;
        case 'poor':
          displayCondition = 'Buruk';
          break;
        case 'damaged':
          displayCondition = 'Rusak';
          break;
        default:
          displayCondition = 'Tidak Diketahui';
      }
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .value = inventoryData['id'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
          .value = inventoryData['item_code'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
          .value = inventoryData['name'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
          .value = inventoryData['category'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
          .value = inventoryData['description'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
          .value = inventoryData['quantity'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
          .value = inventoryData['unit'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
          .value = inventoryData['purchase_date'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
          .value = inventoryData['purchase_price'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex))
          .value = inventoryData['current_value'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex))
          .value = displayCondition;
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: rowIndex))
          .value = inventoryData['location'];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 12, rowIndex: rowIndex))
          .value = inventoryData['responsible_person'];
    }
  }

  // Check and request storage permissions
  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        return status.isGranted;
      }
      return true;
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
        return status.isGranted;
      }
      return true;
    }
    return true;
  }
}