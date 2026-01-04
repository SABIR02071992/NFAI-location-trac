class PunchOutResponse {
  final String archivedSessionId;
  final String message;

  PunchOutResponse({
    required this.archivedSessionId,
    required this.message,
  });

  factory PunchOutResponse.fromJson(Map<String, dynamic> json) {
    return PunchOutResponse(
      archivedSessionId: json['archived_session_id'],
      message: json['message'],
    );
  }
}
