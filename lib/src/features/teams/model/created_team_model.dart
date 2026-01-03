class CreatedTeamModel {
  final String id;
  final String name;
  final String teamLeadId;
  final String teamLeadName;
  final DateTime createdAt;

  CreatedTeamModel({
    required this.id,
    required this.name,
    required this.teamLeadId,
    required this.teamLeadName,
    required this.createdAt,
  });

  factory CreatedTeamModel.fromJson(Map<String, dynamic> json) {
    return CreatedTeamModel(
      id: json['id'] as String,
      name: json['name'] as String,
      teamLeadId: json['team_lead_id'] as String,
      teamLeadName: json['team_lead_name'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'team_lead_id': teamLeadId,
      'team_lead_name': teamLeadName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

