import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/features/storage/KStorage.dart';
import '../../constant/api_ends_point.dart';
import '../../network/api_helper.dart';
import '../model/login_state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(),
);

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(const LoginState());

  final storage = GetStorage();

  /// ================= LOGIN =================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Email & password required');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await ApiHelper.post(
        ApiEndpoints.login,
        body: {"email": email, "password": password},
      );

      debugPrint('#Response => $response');

      /// ✅ SUCCESS
      if (response['statusCode'] == 200 &&
          response['data'] != null &&
          response['data']['access_token'] != null) {

        final data = response['data'];
        final user = data['user'];

        final String userName = user['name'];
        final String email = user['email'];
        final String designation = user['designation'];
        final String roleName = user['assignments'][0]['role_name'];
        final String userId = user['id'];

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: data['access_token'],
          user: user,
        );

        storage.write(KStorageKey.accessToken, data['access_token']);
        storage.write(KStorageKey.userName, userName);
        storage.write(KStorageKey.userEmail, email);
        storage.write(KStorageKey.userRole, roleName);
        storage.write(KStorageKey.designation, designation);
        storage.write(KStorageKey.userId, userId);

        debugPrint('✅ LOGIN SUCCESS');
        debugPrint('TEAM_ID ${storage.read(KStorageKey.selectedTeamId)}');
      } else {
        /// ❌ API ERROR
        state = state.copyWith(
          isLoading: false,
          error: response['data']?['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Network error',
      );
    }

  }

  /// ================= LOGOUT =================
  void logout() {
    state = const LoginState();
    storage.erase();
  }

}
