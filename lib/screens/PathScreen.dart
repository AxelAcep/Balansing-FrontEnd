import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/widgets/menu_button_widget.dart';
import 'package:balansing/screens/Auth/LoginScreen.dart';

class Pathscreen extends StatelessWidget {
  const Pathscreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child : Image.asset('assets/images/Onboard-Logo.png',height: height * 0.08,fit: BoxFit.contain,),
      ),
    );
  }
}