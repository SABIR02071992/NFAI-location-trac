import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/utils/app_colors.dart';
import '../features/storage/KStorage.dart';
import 'k_toast.dart';

class KDrawer extends StatelessWidget {
  const KDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.secondaryColor),
            accountName: Text("Sabir Hussain"),
            accountEmail: Text("shabiransari671@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.secondaryColor, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Teams'),

            onTap: () {
              Get.back(); // close drawer
              //Get.toNamed('/teams_screen');
              Get.toNamed('/teams_screen1');


            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Users'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              final token = storage.remove(KStorageKey.accessToken);
                // Not logged in → Login
                Get.offNamed('/login');

            },
          ),
        ],
      ),
    );
  }
}
