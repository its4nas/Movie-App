import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash.png', height: 200, width: 200),
      ),
    );
  }
}

