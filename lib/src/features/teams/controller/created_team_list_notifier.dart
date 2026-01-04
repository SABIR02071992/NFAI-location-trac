import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/created_team_model.dart';
import '../model/created_team_list_state.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';

final createdTeamListProvider =
    StateNotifierProvider<CreatedTeamListNotifier, CreatedTeamListState>(
      (ref) => CreatedTeamListNotifier(),
    );

class CreatedTeamListNotifier extends StateNotifier<CreatedTeamListState> {
  CreatedTeamListNotifier() : super(const CreatedTeamListState());

  Future<void> fetchTeams({required String loggedInUserId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final teamsResponse = await ApiHelper.post(
        ApiEndpoints.teamLead,
        body: {"user_id": loggedInUserId},
      );

      final List teamList = (teamsResponse['data']?['teams'] ?? []) as List;

      final List<CreatedTeamModel> teams = teamList
          .map((e) => CreatedTeamModel.fromJson(e))
          .toList();

      state = state.copyWith(isLoading: false, teams: teams);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
    }
  }
}
