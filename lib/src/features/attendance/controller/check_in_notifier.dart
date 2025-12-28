import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/check_in_state.dart';

final checkInProvider =
StateNotifierProvider<CheckInNotifier, CheckInState>(
      (ref) => CheckInNotifier(),
);

class CheckInNotifier extends StateNotifier<CheckInState> {
  CheckInNotifier() : super(const CheckInState());

  /// Set location
  void setLocation({required String? lat, required String? lng}) {
    state = state.copyWith(lat: lat, lng: lng);
  }

  /// Check-In
  void checkIn(String desc) {
    if (state.lat == null || state.lng == null) {
      state = state.copyWith(error: 'Location not available');
      return;
    }
    if (desc.isEmpty) {
      state = state.copyWith(error: 'Check-In description is required');
      return;
    }

    state = state.copyWith(
      isCheckedIn: true,
      checkInTime: DateTime.now().toString(),
      checkInDesc: desc,
      error: null,
    );
  }

  /// Check-Out
  void checkOut(String desc) {
    if (desc.isEmpty) {
      state = state.copyWith(error: 'Check-Out description is required');
      return;
    }

    state = state.copyWith(
      isCheckedOut: true,
      checkOutTime: DateTime.now().toString(),
      checkOutDesc: desc,
      error: null,
    );
  }

  /// Reset for next check-in
  void reset() {
    state = const CheckInState();
  }
}
