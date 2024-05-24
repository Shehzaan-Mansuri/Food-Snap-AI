import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_snap/screens/home.dart';
import 'package:food_snap/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Add a delay to navigate to the next screen
    Future.delayed(const Duration(milliseconds: 2600), () {
      // navigate to the next screen also it should scale the screen
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInSine,
            child: const HomeScreen(),
          ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: context.width * 0.2,
            backgroundColor: Colors.deepOrange.shade400.withOpacity(.15),
            child: Lottie.asset(
              'assets/animations/app-intro.json',
              repeat: false,
            ),
          ).animate().scale(
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
              ),
          const SizedBox(height: 20),
          Text(
            'FOOD SNAP',
            style: GoogleFonts.audiowide(
              fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange.shade400,
            ),
            textAlign: TextAlign.center,
          ).animate().slide(
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
              ),
        ],
      ),
    );
  }
}
