import 'package:flutter/material.dart';

import 'screens/study_sort_screen.dart';

void main() {
  runApp(const SortStudyApp());
}

class SortStudyApp extends StatelessWidget {
  const SortStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xff4d6f68);

    return MaterialApp(
      title: 'SortStudy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xfff4f0e8),
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const StudySortScreen(),
    );
  }
}
