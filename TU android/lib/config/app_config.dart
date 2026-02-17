import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConfig {
  // App Information
  static const String appName = 'Sekolah Islam Tata Usaha';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const Color primaryColor = Color(0xFF1E88E5);
  static const Color secondaryColor = Color(0xFF43A047);
  static const Color accentColor = Color(0xFFE53935);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFB8C00);
  static const Color successColor = Color(0xFF43A047);
  static const Color infoColor = Color(0xFF1E88E5);
  
  // Islamic Colors
  static const Color islamicGreen = Color(0xFF009900);
  static const Color islamicGold = Color(0xFFD4AF37);
  static const Color islamicBlue = Color(0xFF1E3A8A);
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  // Storage Keys
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Database Configuration
  static const String databaseName = 'sekolah_islam.db';
  static const int databaseVersion = 1;
  
  // File Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // File Size Limits (in bytes)
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // Supported Image Formats
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  
  // Export Formats
  static const List<String> supportedExportFormats = ['xlsx', 'csv', 'pdf'];
}