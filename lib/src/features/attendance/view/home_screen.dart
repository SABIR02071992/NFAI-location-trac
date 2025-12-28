import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:m_app/src/features/teams/view/add_teams_screen.dart';
import 'package:m_app/src/utils/k_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../controller/check_in_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final checkOutController = TextEditingController();

  final String userName = 'Sabir';

  @override
  void initState() {
    super.initState();

    /*/// simulate GPS
    Future.microtask(() {
      ref
          .read(checkInProvider.notifier)
          .setLocation(lat: '28.6139', lng: '77.2090');
    });*/
  }

  @override
  void dispose() {
    checkOutController.dispose();
    super.dispose();
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkInProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KButton(
                  height: 32,
                  borderRadius: 6,
                  textSize: 16,
                  text: 'Add Team',
                  onPressed: () {
                    _showCreateTeamDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),

            /// ================= CHECK-IN UI =================
            if (!state.isCheckedIn) _checkInUI(),

            /// ================= PUNCH OUT SECTION =================
            _buildPunchOutSection()

          ],
        ),
      ),
    );
  }

  // ================= NEW CHECK-IN UI WIDGETS =================

  Widget _checkInUI() {
    return Column(
      children: [
        // Reusable cards
        _buildPunchInCard(
          title: "Individual Ship Punch-In",
          fields: ["Imo number", "MMSi Number", "Reason (optional)"],
          buttonText: "Punch-In",
          onPressed: () async {

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

            // ✅ Punch-In
            ref.read(checkInProvider.notifier).checkIn(
              desc: 'Punched in Individually',
              lat: position.latitude,
              lng: position.longitude,
            );
          },

        ),

        const SizedBox(height: 16),

        _buildPunchInCard(
          title: "Individual Punch-In",
          fields: ["Latitude", "Longitude", "Reason (optional)"],
          buttonText: "Punch In",
          onPressed: () async {
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

            final position = await LocationHelper.getCurrentLocation();

            if (position == null) {
              Get.snackbar('Location Error', 'Unable to fetch location');
              return;
            }

            ref.read(checkInProvider.notifier).checkIn(
              desc: 'Punched in Individually',
              lat: position.latitude,
              lng: position.longitude,
            );
          },

        ),

        const SizedBox(height: 16),

        _buildPunchInCard(
          title: "Team Field Punch-In",
          fields: ["Reason (optional)"],
          buttonText: "Punch In",
          dropdownItems: ["Team 1", "Team 2"],
          onPressed: () async {
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
            final position = await LocationHelper.getCurrentLocation();

            if (position == null) {
              Get.snackbar('Location Error', 'Unable to fetch location');
              return;
            }

            ref.read(checkInProvider.notifier).checkIn(
              desc: 'Punched in Individually',
              lat: position.latitude,
              lng: position.longitude,
            );
          },

        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPunchOutSection() {
    final state = ref.watch(checkInProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Punch Out",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () async {
                // 1️⃣ Request GPS + location permission
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

                final position = await LocationHelper.getCurrentLocation();

                if (position == null) {
                  Get.snackbar('Location Error', 'Unable to fetch location');
                  return;
                }

                ref.read(checkInProvider.notifier).checkOut(
                  desc: 'Punched out',
                  lat: position.latitude,
                  lng: position.longitude,
                );
              },

              child: Card(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Text("Refresh"),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.isCheckedIn)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPunchOutInfoColumn(
                      "User / Team",
                      "Maintenance Team A",
                    ),
                    _buildPunchOutInfoColumn(
                      "Type",
                      "",
                      valueWidget: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          "TEAM-FIELD",
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    _buildPunchOutInfoColumn("Department", "Maintenance"),
                    _buildPunchOutInfoColumn("Base Location", "Mumbai"),
                    _buildPunchOutInfoColumn(
                      "Punch-In Time",
                      "19 Dec at 07:45 AM",
                    ),
                    _buildPunchOutInfoColumn(
                      "Action",
                      "",
                      valueWidget: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 16,
                        ),
                        label: const Text(
                          "Punch Out",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.1),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),

                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: const SizedBox(
              width: double.infinity,
              height: 100,
              child: Center(child: Text("No session available for punch-out")),
            ),
          ),
      ],
    );
  }

  Widget _buildPunchOutInfoColumn(
    String header,
    String value, {
    Widget? valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            header,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          valueWidget ??
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPunchInCard({
    required String title,
    required List<String> fields,
    required String buttonText,
    List<String>? dropdownItems,
    required VoidCallback onPressed,
  }) {
    String? dropdownValue = dropdownItems?.first;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (dropdownItems != null) ...[
              DropdownButtonFormField<String>(
                value: dropdownValue,
                decoration: const InputDecoration(
                  labelText: 'Select Team',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: dropdownItems.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // In a real app, you'd manage this state.
                },
              ),
              const SizedBox(height: 16),
            ],
            ...fields.map((label) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              );
            }).toList(),
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

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const CreateTeamDialog();
      },
    );
  }
}


