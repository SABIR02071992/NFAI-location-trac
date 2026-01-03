class PunchInResponse {
  final String message;
  final String sessionId;

  PunchInResponse({
    required this.message,
    required this.sessionId,
  });

  factory PunchInResponse.fromJson(Map<String, dynamic> json) {
    return PunchInResponse(
      message: json['message'] ?? '',
      sessionId: json['session_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'session_id': sessionId,
  };
}
