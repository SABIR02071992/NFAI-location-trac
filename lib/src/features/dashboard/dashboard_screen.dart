import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_app/src/features/attendance/view/home_screen.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_drawer.dart';

// ===== Controller =====
class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = const [
    HomeScreen(),
    //TeamScreen(),
    //ProfileScreen(),
  ];

  final List<String> titles = ['Home', 'Teams', 'Profile'];
}

// ===== Main Dashboard =====
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(

                controller.titles[controller.currentIndex.value],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.secondaryColor,
          centerTitle: true,

          // 👇 Change hamburger icon color here
          iconTheme: const IconThemeData(
            color: AppColors.white, // <-- your desired color
            size: 28, // optional: change icon size too
          ),
          actions: [
            IconButton(
              icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              color: Colors.white,
              tooltip: 'Toggle Theme',
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
            ),
          ],
        ),
        drawer: const KDrawer(),
        body: controller.pages[controller.currentIndex.value],
        /*bottomNavigationBar: NavigationBar(
          elevation: 10,

          indicatorColor: AppColors.secondaryColor,
          selectedIndex: controller.currentIndex.value,

          onDestinationSelected: (index) =>
              controller.currentIndex.value = index,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),

            *//*NavigationDestination(
              icon: Icon(Icons.list_alt_outlined),
              selectedIcon: Icon(Icons.list_alt),
              label: 'Team',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),*//*
          ],
        ),*/
      ),
    );
  }
}
