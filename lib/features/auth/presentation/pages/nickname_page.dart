import 'package:expense_manager/features/transaction/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/nickname_textfiled.dart';

class NicknamePage extends StatefulWidget {
  const NicknamePage({super.key});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController controller = TextEditingController();

  bool isValidNickname = false;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      final isValid = controller.text.trim().length >= 3;

      if (isValid != isValidNickname) {
        setState(() {
          isValidNickname = isValid;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.1,
          horizontal: 15,
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isAuthenticated) {
              navigatorKey.currentState?.push(
                MaterialPageRoute(builder: (_) => HomePage()),
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
            children: [
              const Text(
                '👋 What should we call you?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'This name stays only on your device.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              NicknameTextField(
                controller: controller,
                hintText: 'Enter Nickname',
                showTick: isValidNickname,
              ),

              const SizedBox(height: 24),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AuthButton(
                    text: 'Continue',
                    isLoading: state.isLoading,
                    onTap: isValidNickname
                        ? () {
                      context.read<AuthBloc>().add(
                        CreateAccountEvent(
                          controller.text.trim(),
                        ),
                      );
                    }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}