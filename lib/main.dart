import 'package:flutter/material.dart';
import 'package:ideagenis/theme/theme_consts.dart';
import 'package:ideagenis/theme/theme_manager.dart';

import 'screens/create_note.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdeaGenius',
      home: HomeScreen(
        themeManager: _themeManager,
      ),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      debugShowCheckedModeBanner: false,
      routes: {
        "/create-note": (context) => const CreateNotePage(),
      },
    );
  }
}
