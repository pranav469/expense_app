import 'dart:async';

import 'package:expense_manager/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transaction/presentation/pages/home_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/otp_input_field.dart';
import 'nickname_page.dart';

class OtpPage extends StatefulWidget {
  final String mobileNo;

  const OtpPage({
    super.key,
    required this.mobileNo,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String otp = '';

  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    secondsRemaining = 60;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (secondsRemaining > 0) {
          setState(() {
            secondsRemaining--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) {
      return phoneNumber;
    }

    return '${phoneNumber.substring(0, 4)}****${phoneNumber.substring(8)}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maskedPhoneNo = maskPhoneNumber(widget.mobileNo);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   '/home',
              //       (route) => false,
              // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            }

            if (state.needsNickname) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NicknamePage(),
                ),
              );
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verify OTP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Enter the 6-Digit code sent to $maskedPhoneNo',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 6),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'Change Number',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF007AFF),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Text(
                    'OTP: ${state.otp}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              OtpInputField(
                onCompleted: (value) {
                  otp = value;
                },
              ),

              const SizedBox(height: 24),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AuthButton(
                    text: 'Verify',
                    isLoading: state.isLoading,
                    onTap: () {
                      context.read<AuthBloc>().add(
                        VerifyOtpEvent(otp),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              secondsRemaining > 0
                  ? Text(
                'Resend OTP in ${secondsRemaining}s',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
                  : GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(
                    SendOtpEvent(
                      widget.mobileNo,
                    ),
                  );

                  startTimer();
                },
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Color(0xFF007AFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}