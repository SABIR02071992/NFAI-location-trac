import 'live_session_api_response_model.dart';

class ActiveSessionState {
  final bool isLoading;
  final List<ActiveSession> sessions;
  final String? error;

  const ActiveSessionState({
    this.isLoading = false,
    this.sessions = const [],
    this.error,
  });

  ActiveSessionState copyWith({
    bool? isLoading,
    List<ActiveSession>? sessions,
    String? error,
  }) {
    return ActiveSessionState(
      isLoading: isLoading ?? this.isLoading,
      sessions: sessions ?? this.sessions,
      error: error,
    );
  }
}
