import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../network/api_helper.dart';
import '../../constant/api_ends_point.dart';
import '../../storage/KStorage.dart';
import '../model/punch_out_response_model.dart';
import '../model/punch_out_state.dart';

final punchOutProvider =
StateNotifierProvider<PunchOutNotifier, PunchOutState>(
      (ref) => PunchOutNotifier(),
);

class PunchOutNotifier extends StateNotifier<PunchOutState> {
  PunchOutNotifier() : super(const PunchOutState());
  final GetStorage storage = GetStorage();


  Future<void> punchOut({
    required double lat,
    required double lon,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final String sessionId = storage.read(KStorageKey.sessionId);


      final body = {
        "session_id": sessionId,
        "lat": lat,
        "lon": lon,
      };

      final response =
      await ApiHelper.post(ApiEndpoints.punchOut, body: body);

      if (response['statusCode'] == 200 ||
          response['statusCode'] == 201) {
        final result =
        PunchOutResponse.fromJson(response['data']);

        state = state.copyWith(
          isLoading: false,
          response: result,
        );

        // ✅ SUCCESS MESSAGE
        Get.snackbar(
          'Success',
          result.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorMessage =
            response['data']?['error'] ??
                response['data']?['message'] ??
                'Punch-out failed';

        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }
  }
}
