class ApiEndpoints {
  static const baseUrl =
      'http://live-tracking-alb-422583816.me-central-1.elb.amazonaws.com';

  // Auth
  static const login = '/api/login';
  static const logout = '/api/logout';

  // Punch-In / Punch-Out

  static const punchIn = '/api/punch_in';
  static const punchOut = '/api/punch-out';

  // Team lead / team
  static const teamLead = '/api/user/teamlead/teams';
  static const getTeam = '/api/get_teams';

  // Create team

  static const createTeam = '/api/create_team';
  static const getLiveSession = '/api/live_session_field';


}
