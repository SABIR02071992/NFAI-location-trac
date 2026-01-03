/*
class Team {
  final String id;
  final String name;
  final String teamLeadId;
  final String teamLeadName;
  final String createdAt;

  Team({
    required this.id,
    required this.name,
    required this.teamLeadId,
    required this.teamLeadName,
    required this.createdAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      teamLeadId: json['team_lead_id'],
      teamLeadName: json['team_lead_name'],
      createdAt: json['created_at'],
    );
  }
}
*/
class Team {
  final String id;
  final String name;
  final String teamLeadId;
  final String teamLeadName;
  final String createdAt;
  final List<String>? members;           // ← added

  Team({
    required this.id,
    required this.name,
    required this.teamLeadId,
    required this.teamLeadName,
    required this.createdAt,
    this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      teamLeadId: json['team_lead_id'] as String,
      teamLeadName: json['team_lead_name'] as String,
      createdAt: json['created_at'] as String,
      members: json['members'] != null
          ? List<String>.from(json['members'])
          : null,
    );
  }
}