import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../teams/controller/created_team_list_notifier.dart';
import '../../teams/model/created_team_model.dart';
import '../../../utils/k_appbar.dart';
import '../../../utils/k_button.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../controller/punch_in_notifier.dart';

class TeamFieldPunchIn extends ConsumerStatefulWidget {
  const TeamFieldPunchIn({super.key});

  @override
  ConsumerState<TeamFieldPunchIn> createState() => _TeamFieldPunchInState();
}

class _TeamFieldPunchInState extends ConsumerState<TeamFieldPunchIn> {
  String? selectedTeamId;
  final TextEditingController remarksController = TextEditingController();

  // Validation states
  bool _remarksError = false;
  bool _teamError = false;

  // Loader for punch in
  bool _isPunching = false;

  // Store fetched location
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();

    // Fetch ONLY if teams not already loaded
    Future.microtask(() {
      final state = ref.read(createdTeamListProvider);
      if (state.teams.isEmpty && !state.isLoading) {
        ref.read(createdTeamListProvider.notifier).fetchTeams();
      }
    });

    // ✅ Fetch location automatically when screen opens
    Future.microtask(() async {
      final isReady = await LocationPermissionService.checkGpsAndPermission();
      if (!isReady) return;

      final position = await LocationHelper.getCurrentLocation();
      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final teamState = ref.watch(createdTeamListProvider);

    return Scaffold(
      appBar: const KAppBar(title: 'Team Field Punch-In'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (teamState.isLoading && teamState.teams.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : _buildUI(teamState.teams),
      ),
    );
  }

  Widget _buildUI(List<CreatedTeamModel> teams) {
    return Center(
      child: IntrinsicHeight(
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TEAM DROPDOWN
                DropdownButtonFormField<String>(
                  value: selectedTeamId,
                  isExpanded: true,
                  menuMaxHeight: 280,
                  decoration: InputDecoration(
                    labelText: 'Select Team',
                    border: const OutlineInputBorder(),
                    errorText: _teamError ? 'Please select a team' : null,
                  ),
                  items: teams.map((team) {
                    return DropdownMenuItem<String>(
                      value: team.id,
                      child: Text(team.name),
                    );
                  }).toList(),
                  onChanged: _isPunching
                      ? null // disable while loading
                      : (value) {
                    setState(() {
                      selectedTeamId = value;
                      _teamError = false;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // REMARKS FIELD
                TextField(
                  controller: remarksController,
                  enabled: !_isPunching, // disable while loading
                  onChanged: (_) {
                    if (_remarksError) setState(() => _remarksError = false);
                  },
                  decoration: InputDecoration(
                    labelText: 'Reason (required)*',
                    border: const OutlineInputBorder(),
                    errorText: _remarksError ? 'Remarks are required' : null,
                  ),
                ),
                const SizedBox(height: 24),

                // PUNCH IN BUTTON / LOADER
                SizedBox(
                  width: double.infinity,
                  child: _isPunching
                      ? const Center(child: CircularProgressIndicator())
                      : KButton(
                    text: 'Punch In',
                    onPressed: _handlePunchIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _handlePunchIn() async {
    bool hasError = false;
    if (selectedTeamId == null) {
      setState(() => _teamError = true);
      hasError = true;
    }
    if (remarksController.text.trim().isEmpty) {
      setState(() => _remarksError = true);
      hasError = true;
    }
    if (hasError) return;

    if (_latitude == null || _longitude == null) {
      Get.snackbar(
        'Error',
        'Location not available yet. Please wait.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isPunching = true);

    try {
      await ref.read(punchInProvider.notifier).teamFieldPunchIn(
        teamId: selectedTeamId!,
        lat: _latitude!,
        lng: _longitude!,
        description: remarksController.text.trim(),
      );

      final state = ref.read(punchInProvider);
      if (state.isCheckedIn) {
        Get.snackbar(
          'Success',
          state.response?.message ?? 'Punch-in successful',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(milliseconds: 100), () {
          Get.offAllNamed('/dashboard');
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Punch-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isPunching = false);
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }
}
