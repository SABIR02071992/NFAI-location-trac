import 'package:get/get.dart';
import 'package:m_app/src/screens/dashboard/dashboard_screen.dart';
import 'package:m_app/src/screens/login/login_screen.dart';

class KRoutes {
  static final pages = [
    GetPage(name: '/', page: () => const LoginScreen()),
    GetPage(name: '/dashboard', page: () => const DashboardScreen()),
  ];
}
