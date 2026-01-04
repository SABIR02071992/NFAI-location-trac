import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_helper.dart';
import '../../constant/api_ends_point.dart';

final removeTeamProvider = StateNotifierProvider<RemoveTeamNotifier, bool>(
  (ref) => RemoveTeamNotifier(),
);

class RemoveTeamNotifier extends StateNotifier<bool> {
  RemoveTeamNotifier() : super(false);

  Future<void> removeTeam({required String teamId}) async {
    state = true;
    try {
      await ApiHelper.post(ApiEndpoints.removeTeam, body: {'team_id': teamId});
    } finally {
      state = false;
    }
  }
}
