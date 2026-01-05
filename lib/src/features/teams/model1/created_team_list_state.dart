import 'package:equatable/equatable.dart';
import 'created_team_model.dart';

class CreatedTeamListState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<CreatedTeamModel> teams;

  const CreatedTeamListState({
    this.isLoading = false,
    this.error,
    this.teams = const [],
  });

  CreatedTeamListState copyWith({
    bool? isLoading,
    String? error,
    List<CreatedTeamModel>? teams,
  }) {
    return CreatedTeamListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      teams: teams ?? this.teams,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, teams];
}