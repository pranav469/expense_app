import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/onboarding_model.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  final List<OnboardingModel> onboardingData = const [
  OnboardingModel(
    image: 'assets/images/onboarding/onboarding_image.png',
    title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
    description:
    'No ads. No trackers. No third-party analytics.',
  ),
      OnboardingModel(
  image: 'assets/images/onboarding/onboarding_image.png',
  title: 'Insights That Help You Spend Better Without Complexity',
        description:
        'See category-wise spending, recent activity.',
      ),
    OnboardingModel(
      image: 'assets/images/onboarding/onboarding_image.png',
      title: 'Local-First Tracking That Stays Fully On Your Device',
      description:
      'Your finances stay on your phone.',
    ),
  ];

  void nextPage() async {
    if (currentIndex == onboardingData.length - 1) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('onboarding_done', true);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          itemCount: onboardingData.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final item = onboardingData[index];
      
            return OnboardingContent(
              image: item.image,
              title: item.title,
              description: item.description,
      
              indicator: OnboardingIndicator(
                controller: _pageController,
              ),
      
              onSkip: () async {
                final prefs = await SharedPreferences.getInstance();
      
                await prefs.setBool('onboarding_done', true);
      
                if (!mounted) return;
      
                Navigator.pushReplacementNamed(context, '/login');
              },
      
              onNext: nextPage,
      
              buttonText: currentIndex == onboardingData.length - 1
                  ? 'Get Started'
                  : 'Next',
            );
          },
        ),
      ),
    );
  }
}