import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_helper.dart';
import '../../constant/api_ends_point.dart';

final addTeamMemberProvider =
StateNotifierProvider<AddTeamMemberNotifier, bool>(
      (ref) => AddTeamMemberNotifier(),
);

class AddTeamMemberNotifier extends StateNotifier<bool> {
  AddTeamMemberNotifier() : super(false);

  Future<void> addMember({
    required String teamId,
    required String userId,
  }) async {
    state = true;

    try {
      await ApiHelper.post(
        ApiEndpoints.createTeamMember,
        body: {"team_id": teamId, "user_id": userId},
      );
    } finally {
      state = false;
    }
  }
}