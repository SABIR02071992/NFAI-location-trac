

import 'punchin_model.dart';

class IndividualPunchInState {
  final bool isLoading;
  final bool isCheckedIn;
  final PunchInResponse? response;
  final String? error;

  const IndividualPunchInState({
    this.isLoading = false,
    this.isCheckedIn = false,
    this.response,
    this.error,
  });

  IndividualPunchInState copyWith({
    bool? isLoading,
    bool? isCheckedIn,
    PunchInResponse? response,
    String? error,
  }) {
    return IndividualPunchInState(
      isLoading: isLoading ?? this.isLoading,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      response: response ?? this.response,
      error: error,
    );
  }

  Map<String, dynamic> toJson() => {
    'isCheckedIn': isCheckedIn,
    'response': response?.toJson(),
  };

  factory IndividualPunchInState.fromJson(Map<String, dynamic> json) {
    return IndividualPunchInState(
      isCheckedIn: json['isCheckedIn'] ?? false,
      response: json['response'] != null
          ? PunchInResponse.fromJson(json['response'])
          : null,
    );
  }
}

