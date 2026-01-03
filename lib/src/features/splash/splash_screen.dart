import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_assets.dart';

import '../storage/KStorage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Zoom in/out
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide movement
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.repeat(reverse: true);

    // Navigate after splash
    Timer(const Duration(seconds: 4), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    final token = storage.read(KStorageKey.accessToken);
    if (token != null && token.isNotEmpty) {
      // User is logged in → Dashboard
      Get.offNamed('/dashboard');
    } else {
      // Not logged in → Login
      Get.offNamed('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: SlideTransition(
          position: _slideAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  KAssets.welcome_1, // logo image
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
