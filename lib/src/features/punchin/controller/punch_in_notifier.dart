import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import '../model/individual_punch_in_state.dart';
import '../model/punchin_model.dart';
import '../../network/api_helper.dart';
import '../../constant/api_ends_point.dart';
import '../../storage/KStorage.dart';

final punchInProvider =
StateNotifierProvider<CheckInNotifier, IndividualPunchInState>(
      (ref) => CheckInNotifier(),
);

class CheckInNotifier extends StateNotifier<IndividualPunchInState> {
  CheckInNotifier() : super(const IndividualPunchInState());

  final GetStorage storage = GetStorage();

  /// ================= Individual PUNCH IN =================
  Future<void> individualPunchIn({
    required String description,
    required double lat,
    required double lng,
    String sessionType = 'field',
  }) async {
    if (description.trim().isEmpty) {
      state = state.copyWith(error: 'Description is required');
      return;
    }


    try {
      state = state.copyWith(isLoading: true, error: null);

      final String userId = storage.read(KStorageKey.userId);

      final body = {
        "user_id": userId,
        "description": description,
        "session_type": sessionType,
        "lat": lat.toString(),
        "lon": lng.toString(),
      };

      debugPrint('PunchIn BODY => $body');

      final response =
      await ApiHelper.post(ApiEndpoints.punchIn, body: body);

      debugPrint('PunchIn RESPONSE => $response');

      if (response['statusCode'] == 201) {
        final punchInResponse =
        PunchInResponse.fromJson(response['data']);

        state = state.copyWith(
          isLoading: false,
          isCheckedIn: true,
          response: punchInResponse,
        );

        storage.write(
          KStorageKey.sessionId,
          punchInResponse.sessionId,
        );
      } else {
        // 🔥 Show snackbar directly for any API error
        final errorMessage = response['data']['error'] ??
            response['data']['message'] ??
            'Punch-in failed';

        state = state.copyWith(isLoading: false, error: errorMessage);
        debugPrint('Punch In Success: false');
        debugPrint('Punch In Error: $errorMessage');

        // 🔴 SHOW SNACKBAR HERE
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
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


  /// ---------------- Team Field Punch-in
  Future<void> teamFieldPunchIn({
    required String description,
    required double lat,
    required double lng,
    required String teamId,
    String sessionType = 'team-field',
  }) async {
    if (description.trim().isEmpty) {
      state = state.copyWith(error: 'Description is required');
      debugPrint('Validation failed: Description is empty');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      // 🔥 READ USER ID & TEAM ID FROM STORAGE
      final String userId = storage.read(KStorageKey.userId) ?? '';
      final String selectedTeamId = storage.read(KStorageKey.selectedTeamId) ?? '';

      // 🔥 DEBUG PRINTS
      debugPrint('User ID: $userId');
      debugPrint('Selected Team ID from storage: $selectedTeamId');
      debugPrint('Team ID param: $teamId');
      debugPrint('Lat: $lat, Lng: $lng');
      debugPrint('Description/Remarks: $description');

      // 🔥 FINAL BODY TO SEND
      final body = {
        "team_id": teamId,
        "user_id": userId,
        "session_type": sessionType,
        "description": description,
        "lat": lat.toString(),
        "lon": lng.toString(),
      };

      debugPrint('Final API Body: $body');

      final response = await ApiHelper.post(ApiEndpoints.punchIn, body: body);

      debugPrint('Punch In Response raw: $response');

      if (response['statusCode'] == 201) {
        final punchInResponse = PunchInResponse.fromJson(response['data']);
        state = state.copyWith(
          isLoading: false,
          isCheckedIn: true,
          response: punchInResponse,
        );

        storage.write(KStorageKey.sessionId, punchInResponse.sessionId);
        debugPrint('Punch In Success: true');

        // ✅ Success ke baad Home screen redirect
        Get.offAllNamed('/dashboard');

      } else {
        // 🔥 Show snackbar directly for any API error
        final errorMessage = response['data']['error'] ??
            response['data']['message'] ??
            'Punch-in failed';

        state = state.copyWith(isLoading: false, error: errorMessage);
        debugPrint('Punch In Success: false');
        debugPrint('Punch In Error: $errorMessage');

        // 🔴 SHOW SNACKBAR HERE
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, st) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      debugPrint('Punch In Exception: $e');
      debugPrint('StackTrace: $st');

      // 🔴 SHOW SNACKBAR FOR NETWORK ERROR
      Get.snackbar(
        'Error',
        'Network error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }



  /// ---------------- Individual Ship Punch-in
  Future<void> individualShipPunchIn({
    required String description,
    required double lat,
    required double lng,
    String sessionType = 'individual-ship',
    String? shipName,
    String? imoNumber,
    String? mmsiNumber,
  }) async {
    if (description.trim().isEmpty) {
      state = state.copyWith(error: 'Description is required');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final String userId = storage.read(KStorageKey.userId);

      final body = {
        "user_id": userId,
        "ship_name": shipName,
        "imo_number": imoNumber,
        "mmsi_number": mmsiNumber,
        "session_type": sessionType,
        "description": description,
        "lat": lat.toString(),
        "lon": lng.toString(),
      };

      final response =
      await ApiHelper.post(ApiEndpoints.punchIn, body: body);

      if (response['statusCode'] == 201) {
        final punchInResponse =
        PunchInResponse.fromJson(response['data']);

        state = state.copyWith(
          isLoading: false,
          isCheckedIn: true,
          response: punchInResponse,
        );

        storage.write(
          KStorageKey.sessionId,
          punchInResponse.sessionId,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['data']['message'] ?? 'Punch-in failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }
  }

  /// ---------------- Team Ship Punch-in
  Future<void> teamShipPunchIn({
    required String description,
    required double lat,
    required double lng,
    String sessionType = 'team-ship',
    String? shipName,
    String? imoNumber,
    String? mmsiNumber,
  }) async {
    if (description.trim().isEmpty) {
      state = state.copyWith(error: 'Description is required');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final String userId = storage.read(KStorageKey.userId);
      final String selectedTeamId =
      storage.read(KStorageKey.selectedTeamId);

      final body = {
        "team_id": selectedTeamId,
        "user_id": userId,
        "ship_name": shipName,
        "imo_number": imoNumber,
        "mmsi_number": mmsiNumber,
        "session_type": sessionType,
        "description": description,
        "lat": lat.toString(),
        "lon": lng.toString(),
      };

      final response =
      await ApiHelper.post(ApiEndpoints.punchIn, body: body);

      if (response['statusCode'] == 201) {
        final punchInResponse =
        PunchInResponse.fromJson(response['data']);

        state = state.copyWith(
          isLoading: false,
          isCheckedIn: true,
          response: punchInResponse,
        );

        storage.write(
          KStorageKey.sessionId,
          punchInResponse.sessionId,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['data']['message'] ?? 'Punch-in failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }
  }

  /// ✅ ONLY ONE RESET
  void reset() {
    state = const IndividualPunchInState();
  }
}

