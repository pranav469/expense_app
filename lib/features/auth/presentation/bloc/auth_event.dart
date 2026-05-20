import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String enteredOtp;

  const VerifyOtpEvent(this.enteredOtp);

  @override
  List<Object?> get props => [enteredOtp];
}

class CreateAccountEvent extends AuthEvent {
  final String nickname;

  const CreateAccountEvent(this.nickname);

  @override
  List<Object?> get props => [nickname];
}