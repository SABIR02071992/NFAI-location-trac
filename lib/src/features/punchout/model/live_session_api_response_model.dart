class ActiveLiveSessionResponse {
  final List<ActiveSession> activeSessions;

  ActiveLiveSessionResponse({required this.activeSessions});

  factory ActiveLiveSessionResponse.fromJson(Map<String, dynamic> json) {
    return ActiveLiveSessionResponse(
      activeSessions: (json['active_sessions'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => ActiveSession.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ActiveSession {
  final Location? location;
  final DateTime? punchInTime;
  final String remarks;
  final ReportingManager? reportingManager;
  final String sessionId;
  final String sessionType;
  final TeamInfo? teamInfo;
  final ReportingManager? user;

  ActiveSession({
    this.location,
    this.punchInTime,
    required this.remarks,
    this.reportingManager,
    required this.sessionId,
    required this.sessionType,
    this.teamInfo,
    this.user,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      sessionId: json['session_id']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      remarks: json['remarks'] ?? '',

      punchInTime: json['punch_in_time'] != null
          ? DateTime.tryParse(json['punch_in_time'])
          : null,

      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,

      reportingManager: json['reporting_manager'] != null
          ? ReportingManager.fromJson(json['reporting_manager'])
          : null,

      teamInfo: json['team_info'] != null
          ? TeamInfo.fromJson(json['team_info'])
          : null,

      user: json['user'] != null
          ? ReportingManager.fromJson(json['user'])
          : null,
    );
  }
}

class Location {
  final double lat;
  final double lon;

  Location({required this.lat, required this.lon});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ReportingManager {
  final String department;
  final String designation;
  final String email;
  final int hierarchyLevel;
  final dynamic id;
  final String name;
  final String phone;
  final String role;
  final String? baseLocation;

  ReportingManager({
    required this.department,
    required this.designation,
    required this.email,
    required this.hierarchyLevel,
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.baseLocation,
  });

  factory ReportingManager.fromJson(Map<String, dynamic> json) {
    return ReportingManager(
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      hierarchyLevel: json['hierarchy_level'] ?? 0,
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      baseLocation: json['base_location'],
    );
  }
}

class TeamInfo {
  final int memberCount;
  final List<Member> members;
  final String teamId;
  final String teamLead;
  final String teamName;

  TeamInfo({
    required this.memberCount,
    required this.members,
    required this.teamId,
    required this.teamLead,
    required this.teamName,
  });

  factory TeamInfo.fromJson(Map<String, dynamic> json) {
    return TeamInfo(
      memberCount: json['member_count'] ?? 0,
      members: (json['members'] as List? ?? [])
          .where((e) => e != null)
          .map((e) => Member.fromJson(e))
          .toList(),
      teamId: json['team_id']?.toString() ?? '',
      teamLead: json['team_lead'] ?? '',
      teamName: json['team_name'] ?? '',
    );
  }
}

class Member {
  final String designation;
  final String email;
  final dynamic id;
  final String name;

  Member({
    required this.designation,
    required this.email,
    required this.id,
    required this.name,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
