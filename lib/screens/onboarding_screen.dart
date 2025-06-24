import 'package:balansing/screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/PathScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector( // Use GestureDetector to detect taps anywhere on the screen
        onTap: () {
          // Navigate to PathScreen when the screen is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen(Jenis: true,)),
          );
        },
        child: Center(
          child: Image.asset(
            'assets/images/Onboard-Logo.png',
            height: height * 0.3,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}