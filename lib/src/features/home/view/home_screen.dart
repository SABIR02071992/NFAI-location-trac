import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/k_button.dart';
import '../../../utils/k_snackbar.dart';
import '../../../utils/location_helper.dart';
import '../../../utils/location_permission.dart';
import '../../punchout/controller/get_live_session_notifier.dart';
import '../../punchout/controller/punch_out_notifier.dart';
import '../../punchout/model/live_session_api_response_model.dart';
import '../../punchout/model/live_session_state.dart';
import '../../storage/KStorage.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final storage = GetStorage();
  Timer? _timer;
  bool _isPunchOutLoading = false;
  double? _lat;
  double? _lng;

  @override
  void initState() {
    super.initState();
    _getLocation();

    Future.microtask(() {
      ref.read(liveSessionProvider.notifier).getLiveSession();
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _getLocation();
      ref.read(liveSessionProvider.notifier).getLiveSession();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ================= ACTIVE SESSION FINDER =================
  ActiveSession? _getActiveSession(
      String userId, ActiveSessionState state) {

    if (state.sessions.isEmpty || userId.isEmpty) return null;

    for (final session in state.sessions) {
      final type = session.sessionType?.toLowerCase() ?? '';

      // -------- INDIVIDUAL --------
      if (!type.contains('team') &&
          session.user?.id == userId) {
        return session;
      }

      // -------- TEAM --------
      if (type.contains('team') && session.teamInfo != null) {

        // Team Lead
        if (session.user?.id == userId) {
          return session;
        }

        // Team Member
        if (session.teamInfo!.members
            .any((m) => m.id == userId)) {
          return session;
        }
      }
    }
    return null;
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final userId = (storage.read(KStorageKey.userId) ?? '').toString();
    final state = ref.watch(liveSessionProvider);

    /// ✅ Loader sirf first time
    if (state.isLoading && state.sessions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activeSession = _getActiveSession(userId, state);
    final type = activeSession?.sessionType?.toLowerCase() ?? '';

    /// -------- ROLE DETECTION --------
    final isIndividualPunchIn =
        activeSession != null &&
            !type.contains('team') &&
            activeSession.user?.id == userId;

    print("❌ isIndividualPunchIn: $isIndividualPunchIn");



    final isTeamLead =
        activeSession != null &&
            type.contains('team') &&
            activeSession.user?.id == userId;
    print("❌ isTeamLead: $isTeamLead");

    final isTeamMember =
        activeSession != null &&
            type.contains('team') &&
            activeSession.teamInfo != null &&
            activeSession.teamInfo!.members
                .any((m) => m.id == userId);

    print("❌ isTeamMember: $isTeamMember");

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// ================= NO ACTIVE SESSION =================
            if (activeSession == null) ...[
              _sectionTitle("Punch-In Options"),

              _punchInCard(
                label: "Individual Ship Punch-In",
                route: "/punch_in_individual_ship",
              ),
              _punchInCard(
                label: "Individual Punch-In",
                route: "/individual_punch_in",
              ),
              _punchInCard(
                label: "Team Field Punch-In",
                route: "/team_field_punch_in",
              ),
              _punchInCard(
                label: "Team Ship Punch-In",
                route: "/team_ship_punch_in",
              ),
            ]

            /// ================= PUNCH-OUT =================
            else if (isIndividualPunchIn || isTeamLead) ...[
              _sectionTitle("Active Session"),
              _punchOutCard(activeSession),
            ]

            /// ================= TEAM MEMBER =================
            else if (isTeamMember) ...[
                _sectionTitle("Active Team Session"),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        "You are LoggedIn as a Team, only team lead can punch you out",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _punchInCard({
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.login, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= PUNCH OUT CARD =================
  Widget _punchOutCard(ActiveSession session) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${session.user?.name ?? '-'}"),
            Text("Department: ${session.user?.department ?? '-'}"),
            Text("Designation: ${session.user?.designation ?? '-'}"),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              width: 150,
              child: _isPunchOutLoading
                  ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
                  : KButton(
                text: "Punch-Out",
                onPressed: () {


                  // ✅ CHECK LAT-LONG FIRST
                  if (_lat == null ||
                      _lng == null ||
                      _lat.toString().isEmpty ||
                      _lng.toString().isEmpty) {


                    Get.snackbar(
                      'Error',
                      'Please wait, fetching your Location...',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return; // ❌ API CALL STOP
                  }

                  // ✅ CALL API ONLY IF LAT-LONG PRESENT
                  _callPunchOutAPI(session.sessionId);
                },
              ),

            ),
          ],
        ),
      ),
    );
  }

  // ================= API =================
  Future<void> _callPunchOutAPI(String sessionId) async {
    setState(() => _isPunchOutLoading = true);

    try {
      await ref.read(punchOutProvider.notifier).punchOut(
        lat: _lat!,
        lon: _lng!,
        sessionId: sessionId,
      );

      ref.read(liveSessionProvider.notifier).getLiveSession();
    } finally {
      setState(() => _isPunchOutLoading = false);
    }
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
}
