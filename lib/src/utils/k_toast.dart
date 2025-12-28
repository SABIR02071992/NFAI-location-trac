import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_app/src/utils/app_colors.dart';

class KToast {
  static void show(String message, {Color background = Colors.black87}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: background,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void showSuccess(String message) {
    show(message, background: AppColors.greenPrimary);
  }

  static void showError(String message) {
    show(message, background: AppColors.redPrimary);
  }

  static void showInfo(String message) {
    show(message, background: AppColors.blueColor);
  }
}
