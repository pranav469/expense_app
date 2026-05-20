import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputField extends StatelessWidget {
  final Function(String) onCompleted;

  const OtpInputField({
    super.key,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Pinput(
      length: 6,
      onCompleted: onCompleted,

      defaultPinTheme: defaultTheme,

      preFilledWidget: Container(
        width: 20,
        height: 2,
        color: Colors.grey,
      ),
    );
  }
}