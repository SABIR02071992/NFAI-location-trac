
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_button.dart';
import 'package:m_app/src/utils/k_snackbar.dart';
import '../forgotpassword/forgotpassword_screen.dart';
import '../punchin/controller/get_team_notifier.dart';
import '../storage/KStorage.dart';
import 'controller/login_notifier.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome to Goltens\nLive Tracking",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscureText = true;
  final storage = GetStorage();


  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Call Login API
      await ref.read(loginProvider.notifier).login(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final state = ref.read(loginProvider);

      if (state.isLoggedIn) {
        Get.offNamed('/dashboard');
        KSnackBar.showSuccess('Login Successful!');

        // Call Get Team API
        await ref.read(getTeamProvider.notifier).getAllTeam();
        debugPrint('TEAM_ID ${storage.read(KStorageKey.selectedTeamId)}');


      } else if (state.error != null) {
        KSnackBar.showError(state.error!);
        ///print('TEAM_ID $storage.read(KStorageKey.selectedTeamId)');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider); // watch loginProvider for loader

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          const Text(
            'Email *',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              hintText: 'you@example.com',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              suffixIcon: const Icon(Icons.tune),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your email';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                  .hasMatch(value)) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password Field
          const Text(
            'Password *',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _password,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: 'Your password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              suffixIcon: IconButton(
                icon: Icon(_obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter your password';
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Sign In Button with loader
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                KButton(
                  text: 'Sign In',
                  onPressed: loginState.isLoading ? null : _submit,
                  color: const Color(0xFF3B82F6),
                  height: 48,
                  borderRadius: 8,
                ),
                if (loginState.isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Forgot Password
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Get.to(() => const ForgotPasswordScreen()),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Forgot password?",
                style: TextStyle(color: Color(0xFF3B82F6), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
