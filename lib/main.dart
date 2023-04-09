import 'package:flutter/material.dart';
import 'package:ideagenis/utils/note_colors.dart';
import 'package:yaru/yaru.dart';

import 'components/note_card.dart';
import 'pages/create_note.dart';

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
          child: const MyHomePage(title: "IdeaGenius"),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _visitCreateNotePage() {
    Navigator.pushNamed(context, "/create-note");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Notas',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          NoteCard(
              color: randomNoteColor(),
              title: "Cocinar un estofado",
              content: "Primero se pica la carne, luego se pone en la olla",
              date: "2022-01-01"),
          NoteCard(
              color: randomNoteColor(),
              title: "Programar una app",
              content: "Primero se pone el código, luego se compila",
              date: "2022-02-01"),
          NoteCard(
              color: randomNoteColor(),
              title: "Programar una app",
              content: "Primero se pone el código, luego se compila",
              date: "2022-02-01"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _visitCreateNotePage,
        tooltip: 'Add',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
