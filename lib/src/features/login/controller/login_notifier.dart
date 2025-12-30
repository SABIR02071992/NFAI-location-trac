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
      // Start loading
      state = state.copyWith(isLoading: true, error: null);

      // API call
      final response = await ApiHelper.post(
        ApiEndpoints.login,
        body: {"email": email, "password": password},
      );
      print('#Response: $response');

      // Success
      if (response['statusCode'] == 200) {
        final data = response['data'];
        final user = data['user'];

        // ✅ Extract values
        final String userName = user['name'];
        final String email = user['email'];
        final String designation = user['designation'];
        final String roleName = user['assignments'][0]['role_name'];

        // ✅ Update state
        state = state.copyWith(
          isLoading: false,
          isLoggedIn: true,
          token: data['access_token'],
          user: user,
        );

        // ✅ Save to storage
        storage.write(KStorageKey.accessToken, data['access_token']);
        storage.write(KStorageKey.userName, userName);
        storage.write(KStorageKey.userEmail, email);
        storage.write(KStorageKey.userRole, roleName);
        storage.write(KStorageKey.designation, designation);

        print("Name: $userName");
        print("Email: $email");
        print("Role: $roleName");
      }
      else {
        // Handle API errors properly
        final errorMsg = response['data']['message'] ??
            response['data']['error'] ??
            'Login failed';
        state = state.copyWith(isLoading: false, error: errorMsg);
      }
    } catch (_) {
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
