import 'package:m_app/src/features/punchin/model/teamlead_team_model.dart';

class TeamState {
  final bool isLoading;
  final List<TeamModel> teams;
  final String? error;

  const TeamState({
    this.isLoading = false,
    this.teams = const [],
    this.error,
  });

  TeamState copyWith({
    bool? isLoading,
    List<TeamModel>? teams,
    String? error,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      teams: teams ?? this.teams,
      error: error,
    );
  }
}
