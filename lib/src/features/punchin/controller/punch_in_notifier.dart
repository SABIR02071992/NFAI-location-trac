import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// ---------------- Team Field Punch-in
  Future<void> teamFieldPunchIn({
    required String description,
    required double lat,
    required double lng,
    String sessionType = 'team-field',
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

