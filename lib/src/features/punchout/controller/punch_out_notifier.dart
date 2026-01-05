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
    required String sessionId, // ✅ yahi use karenge
  }) async {
    print("🔹 punchOut started for sessionId: $sessionId, lat: $lat, lon: $lon");

    try {
      state = state.copyWith(isLoading: true, error: null);

      final body = {
        "session_id": sessionId,
        "lat": lat,
        "lon": lon,
      };

      print("🔹 punchOut API body: $body");

      final response = await ApiHelper.post(ApiEndpoints.punchOut, body: body);

      print("🔹 punchOut API response: $response");

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final result = PunchOutResponse.fromJson(response['data']);
        print("✅ PunchOut Success: ${result.message}");

        state = state.copyWith(isLoading: false, response: result);

        Get.snackbar(
          'Success',
          result.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorMessage = response['data']?['error'] ??
            response['data']?['message'] ??
            'Punch-out failed';
        print("❌ PunchOut Error: $errorMessage");

        state = state.copyWith(isLoading: false, error: errorMessage);

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print("❌ Exception in punchOut: $e");
      print(stackTrace);

      state = state.copyWith(
        isLoading: false,
        error: 'Network error: ${e.toString()}',
      );

      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
