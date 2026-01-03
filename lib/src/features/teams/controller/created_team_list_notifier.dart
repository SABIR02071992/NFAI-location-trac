import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_app/src/features/teams/model/created_team_model.dart';

import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../model/created_team_list_state.dart';


final createdTeamListProvider =
StateNotifierProvider<CreatedTeamListNotifier, CreatedTeamListState>(
      (ref) => CreatedTeamListNotifier(),
);

class CreatedTeamListNotifier
    extends StateNotifier<CreatedTeamListState> {
  CreatedTeamListNotifier() : super(const CreatedTeamListState());

  /// ================= GET TEAMS =================
  /*Future<void> fetchTeams() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await ApiHelper.post(
        ApiEndpoints.getTeam,
      );

      if (response['statusCode'] == 200 &&
          response['data'] != null &&
          response['data']['teams'] != null) {

        final List list = response['data']['teams'];

        final List<CreatedTeamModel> teams = list
            .map((e) => CreatedTeamModel.fromJson(e))
            .toList();

        state = state.copyWith(
          isLoading: false,
          teams: teams,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load teams',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }
  }*/
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
