class TeamResponseModel {
  final List<TeamModel> teams;

  TeamResponseModel({required this.teams});

  factory TeamResponseModel.fromJson(Map<String, dynamic> json) {
    return TeamResponseModel(
      teams: (json['teams'] as List)
          .map((e) => TeamModel.fromJson(e))
          .toList(),
    );
  }
}

class TeamModel {
  final String teamId;
  final String teamName;
  final String teamLeadId;

  TeamModel({
    required this.teamId,
    required this.teamName,
    required this.teamLeadId,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['team_id'],
      teamName: json['team_name'],
      teamLeadId: json['team_lead_id'],
    );
  }
}
