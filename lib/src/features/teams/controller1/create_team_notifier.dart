import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../model/create_team_state.dart';

final createTeamProvider =
StateNotifierProvider<CreateTeamNotifier, CreateTeamState>(
      (ref) => CreateTeamNotifier(),
);

class CreateTeamNotifier extends StateNotifier<CreateTeamState> {
  CreateTeamNotifier() : super(const CreateTeamState());

  Future<void> createTeam({
    required String teamName,
    required String teamLeadId,
  }) async {
    if (teamName.isEmpty) {
      state = state.copyWith(error: 'Team name is required');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await ApiHelper.post(
        ApiEndpoints.createTeam,
        body: {
          "name": teamName,
          "team_lead_id": teamLeadId,
        },
      );

      if (response['statusCode'] == 200 ||
          response['statusCode'] == 201) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: response['data']['message'],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Team creation failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }
  }

  void reset() {
    state = const CreateTeamState();
  }
}