// lib/splash_screen.dart

import 'package:celebrare/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delay navigation to home page
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const Home(), // Replace HomePage() with your actual home page widget
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, // Background color of the splash screen
      body: Center(
        child: Image.asset(
          'assets/images/celebrareLogo.jpeg', // Path to your logo image
          width: 150, // Adjust size as needed
          height: 150, // Adjust size as needed
        ),
      ),
    );
  }
}
