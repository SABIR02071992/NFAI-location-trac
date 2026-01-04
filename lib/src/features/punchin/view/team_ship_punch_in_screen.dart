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
  ConsumerState<TeamShipPunchIn> createState() => _TeamShipPunchInState();
}

class _TeamShipPunchInState extends ConsumerState<TeamShipPunchIn> {
  // 🔹 Controllers
  final TextEditingController imoController = TextEditingController();
  final TextEditingController mmsiController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // 🔹 Dropdown
  String? selectedTeam;

  // 🔹 Validation flags
  bool _teamError = false;
  bool _imoError = false;
  bool _mmsiError = false;
  bool _reasonError = false;

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

  /// 🔥 Punch-In Logic with validation
  Future<void> _handlePunchIn() async {
    bool hasError = false;

    if (selectedTeam == null) {
      _teamError = true;
      hasError = true;
    }
    if (imoController.text.trim().isEmpty) {
      _imoError = true;
      hasError = true;
    }
    if (mmsiController.text.trim().isEmpty) {
      _mmsiError = true;
      hasError = true;
    }
    if (reasonController.text.trim().isEmpty) {
      _reasonError = true;
      hasError = true;
    }

    setState(() {});

    if (hasError) return;

    // 🔐 Location check
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

    final position = await LocationHelper.getCurrentLocation();

    if (position == null) {
      Get.snackbar(
        'Location Error',
        'Unable to fetch location',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ API call
    ref.read(punchInProvider.notifier).teamShipPunchIn(
      description: reasonController.text.trim(),
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

            // 🔽 DROPDOWN WITH ERROR
            if (dropdownItems != null) ...[
              DropdownButtonFormField<String>(
                value: selectedTeam,
                decoration: InputDecoration(
                  labelText: 'Select Team',
                  border: const OutlineInputBorder(),
                  errorText:
                  _teamError ? 'Please select a team' : null,
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
                  setState(() {
                    selectedTeam = value;
                    _teamError = false;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            // IMO
            TextField(
              controller: imoController,
              onChanged: (_) {
                if (_imoError) setState(() => _imoError = false);
              },
              decoration: InputDecoration(
                labelText: fields[0],
                border: const OutlineInputBorder(),
                errorText:
                _imoError ? 'IMO Number is required' : null,
              ),
            ),
            const SizedBox(height: 16),

            // MMSI
            TextField(
              controller: mmsiController,
              onChanged: (_) {
                if (_mmsiError) setState(() => _mmsiError = false);
              },
              decoration: InputDecoration(
                labelText: fields[1],
                border: const OutlineInputBorder(),
                errorText:
                _mmsiError ? 'MMSI Number is required' : null,
              ),
            ),
            const SizedBox(height: 16),

            // Reason
            TextField(
              controller: reasonController,
              onChanged: (_) {
                if (_reasonError)
                  setState(() => _reasonError = false);
              },
              decoration: InputDecoration(
                labelText: fields[2],
                border: const OutlineInputBorder(),
                errorText:
                _reasonError ? 'Reason is required' : null,
              ),
            ),
            const SizedBox(height: 16),

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

  @override
  void dispose() {
    imoController.dispose();
    mmsiController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}
