import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final String otp;
  final bool userExists;
  final String token;
  final String nickname;
  final String phone;
  final bool isAuthenticated;
  final bool needsNickname;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.otp = '',
    this.userExists = false,
    this.token = '',
    this.nickname = '',
    this.phone = '',
    this.isAuthenticated = false,
    this.needsNickname = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    String? otp,
    bool? userExists,
    String? token,
    String? nickname,
    String? phone,
    bool? isAuthenticated,
    bool? needsNickname,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      otp: otp ?? this.otp,
      userExists: userExists ?? this.userExists,
      token: token ?? this.token,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      isAuthenticated:
      isAuthenticated ?? this.isAuthenticated,
      needsNickname:
      needsNickname ?? this.needsNickname,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    otp,
    userExists,
    token,
    nickname,
    phone,
    isAuthenticated,
    needsNickname,
    error,
  ];
}