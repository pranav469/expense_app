class AuthResponseModel {
  final String otp;
  final bool userExists;
  final String? nickname;
  final String token;

  AuthResponseModel({
    required this.otp,
    required this.userExists,
    required this.nickname,
    required this.token,
  });

  factory AuthResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AuthResponseModel(
      otp: json['otp'] ?? '',
      userExists: json['user_exists'] ?? false,
      nickname: json['nickname'],
      token: json['token'] ?? '',
    );
  }
}