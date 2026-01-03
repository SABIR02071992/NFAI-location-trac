import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../controller/punch_in_notifier.dart';

class TeamShipPunchIn extends ConsumerStatefulWidget {
  const TeamShipPunchIn({super.key});

  @override
  ConsumerState<TeamShipPunchIn> createState() =>
      _TeamShipPunchInState();
}

class _TeamShipPunchInState
    extends ConsumerState<TeamShipPunchIn> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(punchInProvider);

    return Scaffold(
      appBar: const KAppBar(
        title: 'Team Ship Punch-In',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!state.isCheckedIn) _checkInUI(),
          ],
        ),
      ),
    );
  }

  Widget _checkInUI() {
    return Column(
      children: [
        _buildPunchInCard(
          title: "Team Ship Punch-In",
          fields: ["IMO Number", "MMSI Number", "Reason (required)*"],
          dropdownItems: ["Team 1", "Team 2"],
          buttonText: "Punch-In",
          onPressed: _handlePunchIn,
        ),
      ],
    );
  }

  /// 🔥 Common punch-in logic
  Future<void> _handlePunchIn() async {
    // 🔐 Check GPS + permission
    final isReady =
    await LocationPermissionService.checkGpsAndPermission();

    if (!isReady) {
      Get.snackbar(
        'Location Required',
        'Please enable GPS to punch in',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 📍 Get location
    final position = await LocationHelper.getCurrentLocation();

    if (position == null) {
      Get.snackbar(
        'Location Error',
        'Unable to fetch location',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Punch-In API call
    ref.read(punchInProvider.notifier).teamShipPunchIn(
      description: 'Punched in Individually',
      lat: position.latitude,
      lng: position.longitude,
    );
  }

  Widget _buildPunchInCard({
    required String title,
    required List<String> fields,
    required String buttonText,
    List<String>? dropdownItems,
    required VoidCallback onPressed,
  }) {
    String? dropdownValue =
    dropdownItems != null ? dropdownItems.first : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (dropdownItems != null) ...[
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: const InputDecoration(
                  labelText: 'Select Team',
                  border: OutlineInputBorder(),
                ),
                items: dropdownItems
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  dropdownValue = value;
                },
              ),
              const SizedBox(height: 16),
            ],

            ...fields.map(
                  (label) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: KButton(
                text: buttonText,
                onPressed: onPressed,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
