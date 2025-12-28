import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:m_app/src/utils/k_appbar.dart';
import 'package:m_app/src/utils/k_button.dart';
import '../controller/team_controller.dart';
import '../model/team_model.dart';

class AddTeamScreen extends ConsumerStatefulWidget {
  const AddTeamScreen({super.key});

  @override
  ConsumerState<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends ConsumerState<AddTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(title: 'Add Team'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _nameField(),
              const SizedBox(height: 16),
              _mobileField(),
              const SizedBox(height: 16),
              _emailField(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child:KButton(text: 'Add Team',onPressed: (){_submit();},)
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(teamProvider.notifier).addTeam(
        Team(
          name: _nameController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
        ),
      );
      Get.back();
    }
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (v) => v!.isEmpty ? 'Enter name' : null,
    );
  }

  Widget _mobileField() {
    return TextFormField(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(labelText: 'Mobile'),
      validator: (v) =>
      v!.length < 10 ? 'Enter valid mobile number' : null,
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (v) =>
      !v!.contains('@') ? 'Enter valid email' : null,
    );
  }
}
