import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineVerse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1016),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00D2FF),
          surface: Color(0xFF1E202B),
        ),
      ),
      home: const HomePage(),
    );
  }
}
