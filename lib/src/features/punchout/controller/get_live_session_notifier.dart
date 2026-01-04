import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../../storage/KStorage.dart';
import '../model/live_session_api_response_model.dart';
import '../model/live_session_state.dart';

final liveSessionProvider =
StateNotifierProvider<LiveSessionNotifier, ActiveSessionState>(
      (ref) => LiveSessionNotifier(),
);

class LiveSessionNotifier extends StateNotifier<ActiveSessionState> {
  LiveSessionNotifier() : super(const ActiveSessionState());

  final GetStorage storage = GetStorage();

  /// ================= PUNCH OUT =================

  Future<void> getLiveSession() async {
    debugPrint('🚀 getLiveSession() CALLED');
    try {
      state = state.copyWith(isLoading: true, error: null);

      // 👇 Use POST instead of GET
      final response = await ApiHelper.post(ApiEndpoints.getLiveSession);

      debugPrint('📤 STATUS => ${response['statusCode']}');
      debugPrint('📥 RESPONSE => ${response['data']}');

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        final result = ActiveLiveSessionResponse.fromJson(response['data']);

        // ✅ USER ID STORE (from response)
        if (result.activeSessions.isNotEmpty) {
          final liveSessionId = result.activeSessions.first.user.id;
          storage.write(KStorageKey.liveSessionId, liveSessionId);
          debugPrint('LiveSession USER ID stored => $liveSessionId');
        }

        state = state.copyWith(
          isLoading: false,
          sessions: result.activeSessions,
          error: null,
        );
      } else {
        final errorMessage = response['data']?['error'] ??
            response['data']?['message'] ??
            'Failed to fetch live session';

        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );

        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('❌ getLiveSession ERROR => $e');
      debugPrint('📍 STACK TRACE => $stackTrace');

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

}
