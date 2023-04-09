import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'components/note_card.dart';
import 'pages/create_note.dart';
import 'utils/notes_storage.dart';

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
  List<Note> _notes = [];

  Future<void> _visitCreateNotePage() async {
    final note = await Navigator.pushNamed(context, "/create-note") as Note?;
    if (note != null) {
      await NotesStorage.addNote(note);
      _loadNotes();
    }
  }

  Future<void> _loadNotes() async {
    final notes = await NotesStorage.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _deleteNote(Note note) async {
    await NotesStorage.deleteNote(note);
    _loadNotes();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return NoteCard(
            color: Color(int.parse(note.color)),
            title: note.title,
            content: note.content,
            date: note.date,
            onDelete: () => _deleteNote(note),
          );
        },
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
