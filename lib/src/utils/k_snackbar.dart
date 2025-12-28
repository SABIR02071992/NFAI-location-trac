import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KSnackBar {
  // ✅ Success Snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  /// Error / Failed Snackbar
  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  /// Info Snackbar (optional)
  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      backgroundColor: Colors.blue.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }
}
