class CheckInState {
  final bool isCheckedIn;
  final bool isCheckedOut;

  final String? checkInTime;
  final String? checkOutTime;

  final String? checkInDesc;
  final String? checkOutDesc;

  final String? lat;
  final String? lng;

  final String? error;

  const CheckInState({
    this.isCheckedIn = false,
    this.isCheckedOut = false,
    this.checkInTime,
    this.checkOutTime,
    this.checkInDesc,
    this.checkOutDesc,
    this.lat,
    this.lng,
    this.error,
  });

  CheckInState copyWith({
    bool? isCheckedIn,
    bool? isCheckedOut,
    String? checkInTime,
    String? checkOutTime,
    String? checkInDesc,
    String? checkOutDesc,
    String? lat,
    String? lng,
    String? error,
  }) {
    return CheckInState(
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isCheckedOut: isCheckedOut ?? this.isCheckedOut,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInDesc: checkInDesc ?? this.checkInDesc,
      checkOutDesc: checkOutDesc ?? this.checkOutDesc,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      error: error,
    );
  }
}
