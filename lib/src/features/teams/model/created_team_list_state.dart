import '../model/created_team_model.dart';

class CreatedTeamListState {
  final bool isLoading;
  final List<CreatedTeamModel> teams;
  final String? error;

  const CreatedTeamListState({
    this.isLoading = false,
    this.teams = const [],
    this.error,
  });

  CreatedTeamListState copyWith({
    bool? isLoading,
    List<CreatedTeamModel>? teams,
    String? error,
  }) {
    return CreatedTeamListState(
      isLoading: isLoading ?? this.isLoading,
      teams: teams ?? this.teams,
      error: error,
    );
  }

  /// Optional helpers
  bool get hasError => error != null && error!.isNotEmpty;
  bool get isEmpty => !isLoading && teams.isEmpty;
}
