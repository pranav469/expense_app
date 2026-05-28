import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../../../main.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  void submit() {
    final isValid = formKey.currentState!.validate();

    if (!isValid) return;

    context.read<AuthBloc>().add(SendOtpEvent(phoneController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.otp.isNotEmpty) {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (_) => OtpPage(mobileNo: state.phone)),
              );
            }

            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          child: Form(
            key: formKey,
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Log In Using Phone & OTP',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 40),

                  AuthTextfield(
                    controller: phoneController,
                    hintText: 'Phone',
                    validator: Validators.validatePhone,
                  ),

                  const SizedBox(height: 24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AuthButton(
                        text: 'Continue',
                        isLoading: state.isLoading,
                        onTap: submit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
