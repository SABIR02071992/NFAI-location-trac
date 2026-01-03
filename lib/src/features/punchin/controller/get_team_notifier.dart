
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/features/storage/KStorage.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../model/get_team_model.dart';
import '../model/get_team_state.dart';

final getTeamProvider = StateNotifierProvider<GetTeamNotifier, GetTeamState>(
      (ref) => GetTeamNotifier(),
);

class GetTeamNotifier extends StateNotifier<GetTeamState> {
  GetTeamNotifier() : super(const GetTeamState());

  final storage = GetStorage();

  /// Current logged-in user ka ID (storage se ya auth se le rahe hain)
  String? get _currentUserId => storage.read('user_id') as String?;

  /// ================= Get all Team + Filter for current user =================
  Future<void> getAllTeam() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await ApiHelper.post(
        ApiEndpoints.getTeam,
      );

      if (response['statusCode'] == 200) {
        final List<dynamic> teamsJson =
        response['data']['teams'] as List<dynamic>;

        debugPrint('Fetch team SUCCESS$response');

        final List<Team> allTeams =
        teamsJson.map((e) => Team.fromJson(e)).toList();

        // ── Current user ke hisaab se teams filter karo ─────────────────────
        final String? userId = _currentUserId;

        if (userId == null) {
          state = state.copyWith(
            isLoading: false,
            error: 'User not logged in. Please login again.',
            teams: const [],
            selectedTeamId: null,
          );
          return;
        }

        // Important: Yahan decide karna hai filter kaise karna hai
        // Option 1: Sirf team lead ho to
        // final userTeams = allTeams.where((t) => t.teamLeadId == userId).toList();

        // Option 2: Team lead ya member ho (agar members field hai model mein)
        final List<Team> userTeams = allTeams.where((team) {
          return team.teamLeadId == userId ||
              (team.members?.any((id) => id == userId) ?? false);
        }).toList();

        // ── Automatically select karo (pehla team ya last saved) ─────────────
        String? selectedTeamId;

        if (userTeams.isNotEmpty) {
          // Last time jo select kiya tha, wahi prefer karo (better UX)
          final lastSelectedId = storage.read('selected_team_id') as String?;

          if (lastSelectedId != null &&
              userTeams.any((t) => t.id == lastSelectedId)) {
            selectedTeamId = lastSelectedId;
          } else {
            selectedTeamId = userTeams.first.id; // default first team
          }
        }

        state = state.copyWith(
          isLoading: false,
          teams: userTeams,
          selectedTeamId: selectedTeamId,
          // selectedTeamLeadId: userTeams.isNotEmpty ? userTeams.first.teamLeadId : null,
          error: null,
        );

        // Selected team ko save kar do taaki next time app open pe wahi rahe
        if (selectedTeamId != null) {
          await storage.write(KStorageKey.selectedTeamId, selectedTeamId);

        }
      } else {
        final errorMsg = response['data']['message'] ??
            response['data']['error'] ??
            'Failed to load teams';

        state = state.copyWith(
          isLoading: false,
          error: errorMsg,
          teams: const [],
          selectedTeamId: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
        teams: const [],
        selectedTeamId: null,
      );
    }
  }

  // Bonus: Agar user manually team change kare to call karna
  void selectTeam(String teamId) {
    if (state.teams.any((team) => team.id == teamId)) {
      state = state.copyWith(selectedTeamId: teamId);
      storage.write('selected_team_id', teamId);
    }
  }
}