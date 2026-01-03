class CreateTeamState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final String? error;

  const CreateTeamState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.error,
  });

  CreateTeamState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    String? error,
  }) {
    return CreateTeamState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
      error: error,
    );
  }
}
