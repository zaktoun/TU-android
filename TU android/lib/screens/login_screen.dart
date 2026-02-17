import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../widgets/custom_widgets.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      
      Map<String, dynamic> result = await _authService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success']) {
        Get.snackbar(
          'Berhasil',
          result['message'],
          backgroundColor: AppConfig.successColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        Get.offAllNamed('/dashboard');
      } else {
        Get.snackbar(
          'Error',
          result['message'],
          backgroundColor: AppConfig.errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: AppConfig.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    
    if (!RegExp(AppConfig.emailPattern).hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    
    if (value.length < AppConfig.minPasswordLength) {
      return 'Password minimal ${AppConfig.minPasswordLength} karakter';
    }
    
    return null;
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Logo and Title
                _buildHeader(),
                
                const SizedBox(height: 40),
                
                // Login Form
                _buildLoginForm(controller),
                
                const SizedBox(height: 24),
                
                // Login Button
                Obx(() => CustomButton(
                  text: 'Masuk',
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                  icon: Icons.login,
                  width: double.infinity,
                )),
                
                const SizedBox(height: 40),
                
                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConfig.islamicGreen,
                AppConfig.islamicBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: AppConfig.islamicGreen.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.mosque,
            color: Colors.white,
            size: 60,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          AppConfig.appName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConfig.primaryColor,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Sistem Tata Usaha Sekolah Islam',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          
          const SizedBox(height: 24),
          
          CustomTextField(
            label: 'Email',
            hint: 'Masukkan email Anda',
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email),
            validator: controller.validateEmail,
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: 16),
          
          Obx(() => CustomTextField(
            label: 'Password',
            hint: 'Masukkan password Anda',
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: controller.validatePassword,
            textInputAction: TextInputAction.done,
            onEditingComplete: controller.login,
          )),
          
          const SizedBox(height: 16),
          
          // Remember me and Forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: false,
                    onChanged: (value) {
                      // Implement remember me functionality
                    },
                    activeColor: AppConfig.primaryColor,
                  )),
                  Text(
                    'Ingat saya',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Implement forgot password functionality
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Lupa Password'),
                      content: const Text(
                        'Silakan hubungi administrator untuk reset password.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Lupa password?',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Default Login:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Email: admin@sekolah.sch.id',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Password: admin123',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Version ${AppConfig.appVersion}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}