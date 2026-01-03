/*
// get_team_state.dart
import 'get_team_model.dart';

class GetTeamState {
  final bool isLoading;
  final String? error;
  final List<Team> teams;               // ← non-nullable + default value
  final String? selectedTeamLeadId;

  const GetTeamState({
    this.isLoading = false,
    this.error,
    this.teams = const [],              // ← very important!
    this.selectedTeamLeadId,
  });

  GetTeamState copyWith({
    bool? isLoading,
    String? error,
    List<Team>? teams,
    String? selectedTeamLeadId,
  }) {
    return GetTeamState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      teams: teams ?? this.teams,
      selectedTeamLeadId: selectedTeamLeadId ?? this.selectedTeamLeadId,
    );
  }
}*/
import 'get_team_model.dart';
class GetTeamState {
  final bool isLoading;
  final String? error;
  final List<Team> teams;
  final String? selectedTeamId;      // ← Naya field

  const GetTeamState({
    this.isLoading = false,
    this.error,
    this.teams = const [],
    this.selectedTeamId,
  });

  GetTeamState copyWith({
    bool? isLoading,
    String? error,
    List<Team>? teams,
    String? selectedTeamId,
  }) {
    return GetTeamState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      teams: teams ?? this.teams,
      selectedTeamId: selectedTeamId ?? this.selectedTeamId,
    );
  }
}