import 'package:flutter/material.dart';
import 'package:ideagenis/theme/theme_manager.dart';

import '../components/note_card.dart';
import '../components/speed_dial.dart';
import '../utils/notes_storage.dart';
import 'note_view.dart';

class HomePage extends StatefulWidget {
  final ThemeManager themeManager;

  const HomePage({super.key, required this.themeManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];

  @override
  void dispose() {
    widget.themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    widget.themeManager.addListener(themeListener);
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IdeaGenius"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/config");
            },
          ),
          Switch(
            value: widget.themeManager.themeMode == ThemeMode.dark,
            onChanged: (value) {
              widget.themeManager.toggleTheme(true);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;
          double screenWidth = MediaQuery.of(context).size.width;

          if (screenWidth >= 1200) {
            crossAxisCount = 4;
          } else if (screenWidth >= 900) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 1;
          }

          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            padding: const EdgeInsets.all(10.0),
            children: List.generate(_notes.length, (index) {
              final note = _notes[index];
              return NoteCard(
                color: Color(int.parse(note.color)),
                title: note.title,
                content: note.content,
                date: note.date,
                onDelete: () => _deleteNote(note),
                onTap: () => _visitNoteViewPage(note),
              );
            }),
          );
        },
      ),
      floatingActionButton: SpeedDialAddTask(
        onTaskCreated: _loadNotes,
      ),
    );
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

  void _visitNoteViewPage(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteViewPage(note: note),
      ),
    );
  }

  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }
}
