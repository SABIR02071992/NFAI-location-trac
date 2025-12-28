
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/profile_provider.dart';
import '../../../utils/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// -------- PROFILE HEADER --------
            _profileHeader(profile.name, profile.role),

            const SizedBox(height: 24),

            /// -------- PROFILE DETAILS --------
            _infoCard('Employee ID', profile.employeeId),
            _infoCard('Email', profile.email),
            _infoCard('Mobile', profile.mobile),
            _infoCard('Role', profile.role),
          ],
        ),
      ),
    );
  }

  /// ---------------- UI WIDGETS ----------------

  Widget _profileHeader(String name, String role) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            name[0],
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          role,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

