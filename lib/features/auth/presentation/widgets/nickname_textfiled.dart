import 'package:flutter/material.dart';

class NicknameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showTick;

  const NicknameTextField({
    super.key,
    required this.controller,
    this.hintText = "Enter Nickname",
    this.showTick = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 20,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),

        suffixIcon: showTick
            ? const Icon(
          Icons.check_circle,
          color: Colors.green,
        )
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}