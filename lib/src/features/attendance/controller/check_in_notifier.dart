import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import '../model/check_in_state.dart';

final checkInProvider =
StateNotifierProvider<CheckInNotifier, CheckInState>(
      (ref) => CheckInNotifier(),
);

class CheckInNotifier extends StateNotifier<CheckInState> {
  CheckInNotifier() : super(const CheckInState());

  final storage = GetStorage();

  /// ================= CHECK-IN =================
  void checkIn({
    required String desc,
    required double lat,
    required double lng,
  }) {
    if (desc.isEmpty) {
      state = state.copyWith(error: 'Check-In description is required');
      return;
    }

    state = state.copyWith(
      lat: lat.toString(),
      lng: lng.toString(),
      isCheckedIn: true,
      isCheckedOut: false,
      checkInTime: DateTime.now().toString(),
      checkInDesc: desc,
      error: null,
    );

    /// Optional: persist locally
    //storage.write('checkInData', state.toJson());
  }

  /// ================= CHECK-OUT =================
  void checkOut({
    required String desc,
    required double lat,
    required double lng,
  }) {
    if (desc.isEmpty) {
      state = state.copyWith(error: 'Check-Out description is required');
      return;
    }

    state = state.copyWith(
      lat: lat.toString(),
      lng: lng.toString(),
      isCheckedOut: true,
      checkOutTime: DateTime.now().toString(),
      checkOutDesc: desc,
      error: null,
    );

    /// Optional: persist locally
    //storage.write('checkOutData', state.toJson());
  }

  /// ================= RESET =================
  void reset() {
    state = const CheckInState();
    storage.erase();
  }
}

