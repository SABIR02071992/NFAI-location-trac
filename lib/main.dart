import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:m_app/src/features/teams/view/add_team_screen.dart';
import 'package:m_app/src/screens/dashboard/dashboard_screen.dart';
import 'package:m_app/src/screens/login/login_screen.dart';
import 'package:m_app/src/screens/welcome/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set global status bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.secondaryColor, // background color
    statusBarIconBrightness: Brightness.dark, // icons color (dark = black icons)
    statusBarBrightness: Brightness.light, // for iOS
  ));

  // Wrap entire app in ProviderScope (for Riverpod)
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Seller App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/add_team', page: () => const AddTeamScreen()),
      ],
    );
  }
}
