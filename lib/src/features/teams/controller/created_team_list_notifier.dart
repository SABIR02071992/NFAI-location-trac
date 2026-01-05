import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../model/created_team_list_state.dart';
import '../model/created_team_model.dart';


final createdTeamListProvider =
StateNotifierProvider<CreatedTeamListNotifier, CreatedTeamListState>(
      (ref) => CreatedTeamListNotifier(),
);

class CreatedTeamListNotifier
    extends StateNotifier<CreatedTeamListState> {
  CreatedTeamListNotifier() : super(const CreatedTeamListState());

  /// ================= GET TEAMS =================

  Future<void> fetchTeams() async {
    print('fetchTeams() called');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('Calling API at: ${ApiEndpoints.getTeam}');

      final response = await ApiHelper.post(ApiEndpoints.getTeam);

      print('Raw response: $response');

      if (response == null || response is! Map) {
        state = state.copyWith(isLoading: false, error: 'Invalid response from server');
        return;
      }

      // 🔹 Correct path to the list
      final List teamList = (response['data']?['teams'] ?? []) as List;

      final List<CreatedTeamModel> teams =
      teamList.map((e) => CreatedTeamModel.fromJson(e)).toList();

      print('Mapped teams: ${teams.map((e) => e.name).toList()}');

      state = state.copyWith(isLoading: false, teams: teams);
    } catch (e, st) {
      print('Error fetching teams: $e');
      print('Stacktrace: $st');
      state = state.copyWith(isLoading: false, error: 'Network error');
    }
  }

}
