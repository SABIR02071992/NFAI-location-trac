import 'punch_out_response_model.dart';

class PunchOutState {
  final bool isLoading;
  final PunchOutResponse? response;
  final String? error;

  const PunchOutState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  PunchOutState copyWith({
    bool? isLoading,
    PunchOutResponse? response,
    String? error,
  }) {
    return PunchOutState(
      isLoading: isLoading ?? this.isLoading,
      response: response,
      error: error,
    );
  }
}
