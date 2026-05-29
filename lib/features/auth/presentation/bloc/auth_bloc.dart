import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUsecase sendOtpUsecase;
  final CreateAccountUsecase createAccountUsecase;

  AuthBloc({
    required this.sendOtpUsecase,
    required this.createAccountUsecase,
  }) : super(const AuthState()) {
    on<SendOtpEvent>(_onSendOtp);

    on<VerifyOtpEvent>(_onVerifyOtp);

    on<CreateAccountEvent>(_onCreateAccount);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
        ),
      );

      final response = await sendOtpUsecase(
        event.phone,
      );

      emit(
        state.copyWith(
          isLoading: false,
          otp: response.otp,
          userExists: response.userExists,
          token: response.token,
          nickname: response.nickname ?? '',
          phone: event.phone,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event,
      Emitter<AuthState> emit,
      ) async {
    if (event.enteredOtp == state.otp) {
      if (state.userExists) {
        final prefs =
        await SharedPreferences.getInstance();

        await prefs.setString(
          'token',
          state.token,
        );

        await prefs.setDouble(
          'limit',
          10000.0,
        );

        await prefs.setString(
          'nickname',
          state.nickname,
        );

        await prefs.setString(
          'phone',
          state.phone,
        );

        emit(
          state.copyWith(
            isAuthenticated: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            needsNickname: true,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          error: 'Invalid OTP',
        ),
      );
    }
  }

  Future<void> _onCreateAccount(
      CreateAccountEvent event,
      Emitter<AuthState> emit,
      ) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
        ),
      );

      final token =
      await createAccountUsecase(
        phone: state.phone,
        nickname: event.nickname,
      );

      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        'token',
        token,
      );

      await prefs.setDouble(
        'limit',
        10000.0,
      );

      await prefs.setString(
        'nickname',
        event.nickname,
      );

      await prefs.setString(
        'phone',
        state.phone,
      );

      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          token: token,
          nickname: event.nickname,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }
}