import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/team_model.dart';

// StateNotifier to manage the team list
class TeamController extends StateNotifier<List<Team>> {
  TeamController() : super([
    // Static team list
    Team(name: 'John Doe', mobile: '1234567890', email: 'john@example.com'),
    Team(name: 'Jane Smith', mobile: '9876543210', email: 'jane@example.com'),
    Team(name: 'Robert Brown', mobile: '5556667777', email: 'robert@example.com'),
    Team(name: 'Emily Johnson', mobile: '4445556666', email: 'emily@example.com'),
  ]);

  void addTeam(Team team) {
    state = [...state, team]; // Add new team dynamically
  }
}

// Provider
final teamProvider = StateNotifierProvider<TeamController, List<Team>>((ref) {
  return TeamController();
});
