import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../controller/punch_in_notifier.dart';

class IndividualShipPunchInScreen extends ConsumerStatefulWidget {
  const IndividualShipPunchInScreen({super.key});

  @override
  ConsumerState<IndividualShipPunchInScreen> createState() =>
      _IndividualShipPunchInScreenState();
}

class _IndividualShipPunchInScreenState
    extends ConsumerState<IndividualShipPunchInScreen> {

  // 🔹 Controllers
  final TextEditingController imoController = TextEditingController();
  final TextEditingController mmsiController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  // 🔹 Validation flags
  bool _imoError = false;
  bool _mmsiError = false;
  bool _reasonError = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(punchInProvider);

    return Scaffold(
      appBar: const KAppBar(
        title: 'Individual Ship Punch-In',
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
          title: "Individual Ship Punch-In",
          buttonText: "Punch-In",
          onPressed: _handlePunchIn,
        ),
      ],
    );
  }

  /// 🔥 Punch-in with validation
  Future<void> _handlePunchIn() async {
    bool hasError = false;

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


    // ✅ Punch-In API call
    ref.read(punchInProvider.notifier).individualShipPunchIn(
      description: reasonController.text.trim(),
      lat: 0.0,
      lng: 0.0,
      mmsiNumber: '',
      imoNumber: '',
      shipName: '',
    );
  }

  Widget _buildPunchInCard({
    required String title,
    required String buttonText,
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

            // IMO NUMBER
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: imoController,
                onChanged: (_) {
                  if (_imoError) setState(() => _imoError = false);
                },
                decoration: InputDecoration(
                  labelText: 'IMO Number',
                  border: const OutlineInputBorder(),
                  errorText: _imoError ? 'IMO Number is required' : null,
                ),
              ),
            ),

            // MMSI NUMBER
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: mmsiController,
                onChanged: (_) {
                  if (_mmsiError) setState(() => _mmsiError = false);
                },
                decoration: InputDecoration(
                  labelText: 'MMSI Number',
                  border: const OutlineInputBorder(),
                  errorText: _mmsiError ? 'MMSI Number is required' : null,
                ),
              ),
            ),

            // REASON
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: reasonController,
                onChanged: (_) {
                  if (_reasonError) setState(() => _reasonError = false);
                },
                decoration: InputDecoration(
                  labelText: 'Reason (required)*',
                  border: const OutlineInputBorder(),
                  errorText:
                  _reasonError ? 'Reason is required' : null,
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

  @override
  void dispose() {
    imoController.dispose();
    mmsiController.dispose();
    reasonController.dispose();
    super.dispose();
  }
}
