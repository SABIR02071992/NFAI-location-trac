class CreatedTeamModel {
  final String id;
  final String name;
  final String teamLeadId;
  final String teamLeadName;
  final DateTime createdAt;
  final List<dynamic> members; // ✅ ADD THIS

  CreatedTeamModel({
    required this.id,
    required this.name,
    required this.teamLeadId,
    required this.teamLeadName,
    required this.createdAt,
    required this.members, // ✅ ADD THIS
  });

  factory CreatedTeamModel.fromJson(Map<String, dynamic> json) {
    return CreatedTeamModel(
      id: json['team_id'] ?? json['id'],
      name: json['team_name'] ?? json['name'],
      teamLeadId: json['team_lead_id'],
      teamLeadName: json['team_lead_name'],
      createdAt: DateTime.parse(json['created_at']),
      members: json['members'] ?? [], // ✅ ADD THIS
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'team_lead_id': teamLeadId,
      'team_lead_name': teamLeadName,
      'created_at': createdAt.toIso8601String(),
      'members': members,
    };
  }
}