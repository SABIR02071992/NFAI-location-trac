import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_helper.dart';
import '../../constant/api_ends_point.dart';

final removeTeamMemberProvider =
StateNotifierProvider<RemoveTeamMemberNotifier, bool>(
      (ref) => RemoveTeamMemberNotifier(),
);

class RemoveTeamMemberNotifier extends StateNotifier<bool> {
  RemoveTeamMemberNotifier() : super(false);

  Future<void> removeMember({required String memberRecordId}) async {
    state = true;

    try {
      final response = await ApiHelper.post(
        ApiEndpoints.removeTeamMember,
        body: {"member_id": memberRecordId},
      );

      if (response['statusCode'] != 200 && response['statusCode'] != 201) {
        throw Exception("Failed to remove member");
      }
    } finally {
      state = false;
    }
  }
}