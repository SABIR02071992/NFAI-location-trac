import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../controller/punch_in_notifier.dart';
import '../model/individual_punch_in_state.dart';

class IndividualPunchIn extends ConsumerStatefulWidget {
  const IndividualPunchIn({super.key});

  @override
  ConsumerState<IndividualPunchIn> createState() =>
      _IndividualPunchInState();
}

class _IndividualPunchInState extends ConsumerState<IndividualPunchIn> {
  final TextEditingController des = TextEditingController();

  double? _lat;
  double? _lng;

  bool _localLoading = false; // 🔥 UI loader flag

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final isReady =
    await LocationPermissionService.checkGpsAndPermission();
    if (!isReady) return;

    final position = await LocationHelper.getCurrentLocation();
    if (position != null) {
      _lat = position.latitude;
      _lng = position.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(punchInProvider);

    // 🔔 Provider listener (loader OFF + snackbars)
    ref.listen<IndividualPunchInState>(punchInProvider, (prev, next) {
      if (_localLoading && next.isLoading == false) {
        setState(() {
          _localLoading = false;
        });
      }

      if (prev?.isCheckedIn == false && next.isCheckedIn == true) {
        Get.snackbar(
          'Success',
          next.response?.message ?? 'Punch-in successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      if (next.error != null && next.error!.isNotEmpty) {
        Get.snackbar(
          'Error',
          next.error!,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });

    return Scaffold(
      appBar: const KAppBar(title: 'Individual Punch-In'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!state.isCheckedIn) _buildPunchInCard(),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePunchIn() async {
    if (_lat == null || _lng == null) {
      Get.snackbar(
        'Error',
        'Location not available yet. Please wait.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 🔥 BUTTON HIT → LOADER ON
    setState(() {
      _localLoading = true;
    });

    ref.read(punchInProvider.notifier).individualPunchIn(
      description: des.text.trim(),
      lat: _lat!,
      lng: _lng!,
    );
  }

  Widget _buildPunchInCard() {
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
            const Text(
              'Individual Punch-In',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            /// 🔹 Reason Field
            TextField(
              controller: des,
              enabled: !_localLoading, // 🔒 disable on loading
              onChanged: (_) {
                ref.read(punchInProvider.notifier).reset();
              },
              decoration: const InputDecoration(
                labelText: 'Reason (required)*',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 BUTTON ↔ LOADER SWITCH
            SizedBox(
              width: double.infinity,
              child: _localLoading
                  ? const Center(
                child: SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
                  : KButton(
                text: 'Punch-In',
                onPressed: _handlePunchIn,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
