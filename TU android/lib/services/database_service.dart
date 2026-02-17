import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../config/app_config.dart';

class DatabaseService {
  static Database? _database;
  static DatabaseService? _instance;
  
  DatabaseService._internal();
  
  static DatabaseService get instance {
    _instance ??= DatabaseService._internal();
    return _instance!;
  }
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConfig.databaseName);
    
    return await openDatabase(
      path,
      version: AppConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL CHECK (role IN ('admin_tu', 'admin_devops')),
        photo TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    // Create students table
    await db.execute('''
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
      )
    ''');
    
    // Create teachers table
    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nip TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        place_of_birth TEXT,
        date_of_birth TEXT,
        gender TEXT CHECK (gender IN ('L', 'P')),
        religion TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        specialization TEXT,
        employment_status TEXT DEFAULT 'active' CHECK (employment_status IN ('active', 'inactive')),
        photo TEXT,
        hire_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    // Create staff table
    await db.execute('''
      CREATE TABLE staff (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nik TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        position TEXT NOT NULL,
        place_of_birth TEXT,
        date_of_birth TEXT,
        gender TEXT CHECK (gender IN ('L', 'P')),
        religion TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        employment_status TEXT DEFAULT 'active' CHECK (employment_status IN ('active', 'inactive')),
        photo TEXT,
        hire_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    // Create classes table
    await db.execute('''
      CREATE TABLE classes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        level TEXT NOT NULL,
        teacher_id INTEGER,
        capacity INTEGER DEFAULT 40,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (teacher_id) REFERENCES teachers (id)
      )
    ''');
    
    // Create financial transactions table
    await db.execute('''
      CREATE TABLE financial_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_code TEXT UNIQUE NOT NULL,
        student_id INTEGER,
        type TEXT NOT NULL CHECK (type IN ('spp', 'iuran', 'zakat', 'infak', 'sedekah', 'tabungan', 'lainnya')),
        amount REAL NOT NULL,
        description TEXT,
        payment_method TEXT CHECK (payment_method IN ('cash', 'transfer', 'digital')),
        payment_date TEXT NOT NULL,
        status TEXT DEFAULT 'paid' CHECK (status IN ('paid', 'pending', 'cancelled')),
        created_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');
    
    // Create savings table
    await db.execute('''
      CREATE TABLE savings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT CHECK (type IN ('deposit', 'withdrawal')),
        description TEXT,
        transaction_date TEXT NOT NULL,
        balance_after REAL NOT NULL,
        created_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES students (id),
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');
    
    // Create inventory table
    await db.execute('''
      CREATE TABLE inventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        quantity INTEGER NOT NULL DEFAULT 0,
        unit TEXT NOT NULL,
        purchase_date TEXT,
        purchase_price REAL,
        current_value REAL,
        condition_status TEXT CHECK (condition_status IN ('good', 'fair', 'poor', 'damaged')),
        location TEXT,
        responsible_person TEXT,
        photo TEXT,
        created_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');
    
    // Create backup logs table
    await db.execute('''
      CREATE TABLE backup_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        backup_type TEXT NOT NULL CHECK (backup_type IN ('full', 'incremental')),
        file_path TEXT NOT NULL,
        file_size REAL,
        backup_date TEXT NOT NULL,
        created_by INTEGER NOT NULL,
        status TEXT DEFAULT 'success' CHECK (status IN ('success', 'failed')),
        description TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');
    
    // Insert default admin user
    await db.insert('users', {
      'email': 'admin@sekolah.sch.id',
      'password': _hashPassword('admin123'),
      'name': 'Administrator',
      'role': 'admin_tu',
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < 2) {
      // Add new columns or tables for version 2
    }
  }
  
  String _hashPassword(String password) {
    // Simple hash for demonstration (use bcrypt in production)
    return password.hashCode.toString();
  }
  
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
  
  // Backup database
  Future<String> backupDatabase() async {
    try {
      String path = join(await getDatabasesPath(), AppConfig.databaseName);
      String backupPath = join(await getDatabasesPath(), 'backup_${DateTime.now().millisecondsSinceEpoch}.db');
      
      // Copy database file
      await DatabaseFactory.instance.copyDatabase(path, backupPath);
      
      // Log backup
      final db = await database;
      await db.insert('backup_logs', {
        'backup_type': 'full',
        'file_path': backupPath,
        'backup_date': DateTime.now().toIso8601String(),
        'created_by': 1, // Default admin
        'status': 'success',
        'created_at': DateTime.now().toIso8601String(),
      });
      
      return backupPath;
    } catch (e) {
      throw Exception('Backup failed: $e');
    }
  }
  
  // Restore database
  Future<void> restoreDatabase(String backupPath) async {
    try {
      String targetPath = join(await getDatabasesPath(), AppConfig.databaseName);
      
      // Close current database
      await close();
      
      // Copy backup file
      await DatabaseFactory.instance.copyDatabase(backupPath, targetPath);
      
      // Reopen database
      _database = await _initDatabase();
    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }
}