class LoginState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? token;
  final Map<String, dynamic>? user;
  final String? error;

  const LoginState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.token,
    this.user,
    this.error,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? token,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      error: error,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoggedIn': isLoggedIn,
    'token': token,
    'user': user,
  };

  factory LoginState.fromJson(Map<String, dynamic> json) {
    return LoginState(
      isLoggedIn: json['isLoggedIn'] ?? false,
      token: json['token'],
      user: json['user'],
    );
  }
}
