import 'package:flutter/material.dart';

import '../../res/app_theme.dart';
import '../common_widget/fade_slide_in.dart';
import '../shell/home_shell.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _start(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, _, _) => const HomeShell(),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -24,
            bottom: 0,
            width: MediaQuery.sizeOf(context).width * 0.9,
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: const FadeSlideIn(
              delay: Duration(milliseconds: 250),
              offset: Offset(0.2, 0),
              child: Image(
                image: AssetImage('assets/images/doctor6.png'),
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                excludeFromSemantics: true,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeSlideIn(
                    child: Text(
                      'Complete\nHealth\nSolution',
                      style: textTheme.headlineMedium?.copyWith(fontSize: 38),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: Text(
                      'Early protection for\nyour family\'s health',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 350),
                    offset: const Offset(-0.5, 0),
                    child: SizedBox(
                      width: 170,
                      height: 60,
                      child: FilledButton(
                        onPressed: () => _start(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Get Started'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
