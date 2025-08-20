import 'package:flutter/material.dart';
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

    return Scaffold(
      body: GestureDetector( // Use GestureDetector to detect taps anywhere on the screen
        onTap: () {
          // Navigate to PathScreen when the screen is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PathScreen()),
          );
        },
        child: Container(
          child: Column( mainAxisAlignment: MainAxisAlignment.start, children: [ 
           SizedBox(height: height*0.26,),
           Image.asset(
            'assets/images/Onboard-Logo.png',
            height: height * 0.3,
            fit: BoxFit.contain,
          ),
          ],) 
        ),
      ),
    );
  }
}