import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:empire_app/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationStart extends StatelessWidget {
  const AnimationStart({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Lottie.asset(
          'assets/Animation/Animation - 1723945058246.json',
        ),
      ),
      duration: 3500,
      nextScreen: const LoginScreen(),
      splashIconSize: MediaQuery.of(context).size.height,
      backgroundColor: Colors.white,
    );
  }
}
