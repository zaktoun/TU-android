import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/database_service.dart';
import '../config/app_config.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GetStorage _storage = GetStorage();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final DatabaseService _dbService = DatabaseService.instance;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final db = await _dbService.database;
      
      // Hash password
      String hashedPassword = _hashPassword(password);
      
      // Query user from database
      List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, hashedPassword],
      );

      if (users.isEmpty) {
        return {
          'success': false,
          'message': 'Email atau password salah',
        };
      }

      // Get user data
      Map<String, dynamic> userData = users.first;
      User user = User.fromJson(userData);

      // Store user session
      await _saveUserSession(user);

      _currentUser = user;

      return {
        'success': true,
        'message': 'Login berhasil',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Clear storage
      await _storage.remove(AppConfig.userKey);
      await _secureStorage.delete(key: AppConfig.tokenKey);
      
      _currentUser = null;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _storage.read(AppConfig.userKey) != null;
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    try {
      if (_currentUser != null) return _currentUser;

      Map<String, dynamic>? userData = _storage.read(AppConfig.userKey);
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        return _currentUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Save user session
  Future<void> _saveUserSession(User user) async {
    try {
      // Save to regular storage (non-sensitive data)
      await _storage.write(AppConfig.userKey, user.toJson());
      
      // Save token to secure storage
      String token = _generateToken(user);
      await _secureStorage.write(key: AppConfig.tokenKey, value: token);
    } catch (e) {
      throw Exception('Failed to save user session: $e');
    }
  }

  // Generate authentication token
  String _generateToken(User user) {
    String payload = jsonEncode({
      'id': user.id,
      'email': user.email,
      'role': user.role,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    String token = base64Encode(utf8.encode(payload));
    return token;
  }

  // Verify token
  Future<bool> verifyToken(String token) async {
    try {
      String decoded = utf8.decode(base64.decode(token));
      Map<String, dynamic> payload = jsonDecode(decoded);
      
      // Check if token is not expired (24 hours)
      int timestamp = payload['timestamp'];
      int now = DateTime.now().millisecondsSinceEpoch;
      
      if (now - timestamp > 24 * 60 * 60 * 1000) {
        return false;
      }
      
      // Get user from database
      final db = await _dbService.database;
      List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'id = ? AND email = ?',
        whereArgs: [payload['id'], payload['email']],
      );

      return users.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Check user role
  bool isAdminTU() {
    return _currentUser?.role == 'admin_tu';
  }

  bool isAdminDevOps() {
    return _currentUser?.role == 'admin_devops';
  }

  bool hasAdminAccess() {
    return isAdminTU() || isAdminDevOps();
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    try {
      if (_currentUser == null) {
        return {
          'success': false,
          'message': 'User not logged in',
        };
      }

      final db = await _dbService.database;
      
      // Verify old password
      String hashedOldPassword = _hashPassword(oldPassword);
      List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [_currentUser!.id, hashedOldPassword],
      );

      if (users.isEmpty) {
        return {
          'success': false,
          'message': 'Password lama salah',
        };
      }

      // Update password
      String hashedNewPassword = _hashPassword(newPassword);
      await db.update(
        'users',
        {
          'password': hashedNewPassword,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );

      return {
        'success': true,
        'message': 'Password berhasil diubah',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile(User updatedUser) async {
    try {
      if (_currentUser == null) {
        return {
          'success': false,
          'message': 'User not logged in',
        };
      }

      final db = await _dbService.database;
      
      await db.update(
        'users',
        {
          'name': updatedUser.name,
          'photo': updatedUser.photo,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [_currentUser!.id],
      );

      // Update current user
      _currentUser = _currentUser!.copyWith(
        name: updatedUser.name,
        photo: updatedUser.photo,
      );

      // Update storage
      await _saveUserSession(_currentUser!);

      return {
        'success': true,
        'message': 'Profile berhasil diperbarui',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Hash password
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate password strength
  bool isPasswordStrong(String password) {
    if (password.length < AppConfig.minPasswordLength) return false;
    if (password.length > AppConfig.maxPasswordLength) return false;
    
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  // Get password strength feedback
  String getPasswordStrengthFeedback(String password) {
    if (password.length < AppConfig.minPasswordLength) {
      return 'Password minimal ${AppConfig.minPasswordLength} karakter';
    }
    
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }
    
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }
    
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password harus mengandung karakter khusus';
    }
    
    return 'Password kuat';
  }
}