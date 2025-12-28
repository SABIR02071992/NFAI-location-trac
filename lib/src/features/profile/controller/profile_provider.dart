import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/profile_model.dart';

final profileProvider = Provider<ProfileModel>((ref) {
  // 🔹 Static data (Replace with API later)
  return ProfileModel(
    name: 'Sabir Hussain Ansari',
    email: 'sabir@gmail.com',
    mobile: '9876543210',
    role: 'Flutter Developer',
    employeeId: 'EMP-1024',
  );
});
