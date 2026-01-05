class TeamModel1 {
  final String id;
  final String teamName;
  final String teamLeadId;
  final String teamLeadName;
  final DateTime createdAt;

  TeamModel1({
    required this.id,
    required this.teamName,
    required this.teamLeadId,
    required this.teamLeadName,
    required this.createdAt,
  });

  factory TeamModel1.fromJson(Map<String, dynamic> json) {
    return TeamModel1(
      id: json['id'],
      teamName: json['name'],
      teamLeadId: json['team_lead_id'],
      teamLeadName: json['team_lead_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}