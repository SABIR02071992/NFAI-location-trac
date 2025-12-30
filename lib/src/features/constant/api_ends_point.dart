class ApiEndpoints {
  static const baseUrl =
      'http://live-tracking-alb-422583816.me-central-1.elb.amazonaws.com';

  // Auth
  static const login = '/api/login';
  static const logout = '/api/logout';

  // Check-In / Check-Out
  static const checkIn = '/api/check-in';
  static const checkOut = '/api/check-out';

  // Projects / Attendance / Other APIs
  static const projects = '/api/projects';
  static const attendance = '/api/attendance';
}
