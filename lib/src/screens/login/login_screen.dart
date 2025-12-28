import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_app/src/screens/forgotpassword/forgotpassword_screen.dart';
import 'package:m_app/src/utils/app_colors.dart';
import 'package:m_app/src/utils/k_button.dart';
import 'package:m_app/src/utils/k_snackbar.dart';

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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _obscureText = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Get.offNamed('/dashboard');
      KSnackBar.showSuccess('Login Successful!');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              if (value == null || value.isEmpty) {
                return 'Enter your email';
              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                  .hasMatch(value)) {
                return 'Enter a valid email';
              }
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
              if (value == null || value.isEmpty) {
                return 'Enter your password';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            child: KButton(
              text: 'Sign In',
              onPressed: _submit,
              color: const Color(0xFF3B82F6), // Blue color from screenshot
              height: 48,
              borderRadius: 8,
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
