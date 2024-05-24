import 'package:flutter/material.dart';
import 'package:food_snap/screens/home.dart';
import 'package:food_snap/screens/splash.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange.shade400,
        bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.deepOrange.shade400.withOpacity(.2)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrange.shade400,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
