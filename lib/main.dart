import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'pages/create_note.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IdeaGenius',
      home: Builder(
        builder: (context) => YaruTheme(
          data: AppTheme.of(context),
          child: const HomePage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/create-note": (context) => Builder(
              builder: (context) => YaruTheme(
                data: AppTheme.of(context),
                child: const CreateNotePage(),
              ),
            ),
      },
    );
  }
}

class AppTheme {
  static YaruThemeData of(BuildContext context) {
    return SharedAppData.getValue(
      context,
      'theme',
      () => const YaruThemeData(),
    );
  }

  static void apply(
    BuildContext context, {
    YaruVariant? variant,
    bool? highContrast,
    ThemeMode? themeMode,
  }) {
    SharedAppData.setValue(
      context,
      'theme',
      AppTheme.of(context).copyWith(
        themeMode: themeMode,
        variant: variant,
        highContrast: highContrast,
      ),
    );
  }
}
