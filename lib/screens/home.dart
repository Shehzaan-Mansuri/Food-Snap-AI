import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_snap/screens/scanFood/camera_preview.dart';
import 'package:food_snap/utils/responsive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Lottie.asset(
          'assets/animations/camera-snap.json',
        ),
        onPressed: () {
          // navigate to the next screen also it should scale the screen
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInSine,
              child: const FoodSnapCameraView(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: context.height * 0.1),
            CircleAvatar(
              radius: context.width * 0.15,
              backgroundColor: Colors.deepOrange.shade400.withOpacity(.15),
              child: Image.asset(
                'assets/icons/logo.png',
                width: context.width * 0.2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: context.height * 0.3,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    "Unlock Your Meal's Macros with a Snap",
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: context.height * 0.04,
                      color: Colors.deepOrange.shade400,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TyperAnimatedText(
                    'Snap a picture of your meal',
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: context.height * 0.04,
                      color: Colors.deepOrange.shade400,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TyperAnimatedText(
                    'Get detailed nutritional information',
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: context.height * 0.04,
                      color: Colors.deepOrange.shade400,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TyperAnimatedText(
                    'Track your macros effortlessly',
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.spaceGrotesk(
                      fontSize: context.height * 0.04,
                      color: Colors.deepOrange.shade400,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                repeatForever: true,
              ),
            ),
            SizedBox(height: context.height * .2),
            Text(
              'Developed by: Shehzaan Mansuri',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.height * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
