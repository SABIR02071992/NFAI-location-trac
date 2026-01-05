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

        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: data['access_token'],
          user: user,
        );

        storage.write(KStorageKey.accessToken, data['access_token']);
        storage.write(KStorageKey.userName, user['name']);
        storage.write(KStorageKey.userEmail, user['email']);
        storage.write(KStorageKey.userRole, user['assignments'][0]['role_name']);
        storage.write(KStorageKey.designation, user['designation']);
        storage.write(KStorageKey.userId, user['id']);

      } else {
        final apiError = response['data']?['error'];

        state = state.copyWith(
          isLoading: false,
          error: apiError ?? 'Invalid email or password',
        );
      }

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to login. Please try again.',
      );
    }
  }

  /// ================= LOGOUT =================
  void logout() {
    state = const LoginState();
    storage.erase();
  }

}
