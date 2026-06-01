import 'package:expense_manager/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Widget indicator;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final String buttonText;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.indicator,
    required this.onSkip,
    required this.onNext,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),

        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.45),
          ),
        ),

        Positioned(
          top: 60,
          right: 24,
          child: GestureDetector(
            onTap: onSkip,
            child: const Text(
              'SKIP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),

        Positioned(
          left: 24,
          right: 24,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              indicator,

              const SizedBox(height: 30),

              Text(
                title,
                style: AppTextStyles.onboardingTitle,
              ),

              const SizedBox(height: 16),

              Text(
                description,
                style: AppTextStyles.onboardingDescription,
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B3DFE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}