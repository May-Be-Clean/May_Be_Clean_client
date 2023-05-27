import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/splash/splash_image.png',
      fit: BoxFit.cover,
    );
  }
}
