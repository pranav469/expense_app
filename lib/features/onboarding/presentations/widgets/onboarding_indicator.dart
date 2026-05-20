import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingIndicator extends StatelessWidget {
  final PageController controller;

  const OnboardingIndicator({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: WormEffect(
        dotHeight: 4,
        dotWidth: 100,
        spacing: 12,
        activeDotColor: Colors.white,
        dotColor: Colors.white.withOpacity(0.2),
        radius: 20,
      ),
    );
  }
}