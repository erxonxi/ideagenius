import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yaru/yaru.dart';

import '../components/note_card.dart';
import '../main.dart';
import '../utils/notes_storage.dart';
import 'note_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _visitNoteViewPage(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YaruTheme(
          data: AppTheme.of(context),
          child: NoteViewPage(note: note),
        ),
      ),
    );
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
            onTap: () => _visitNoteViewPage(note),
          );
        },
      ),
      floatingActionButton: SpeedDial(
          icon: Icons.window_rounded,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              label: 'Add',
              backgroundColor: Colors.grey,
              onTap: _visitCreateNotePage,
            ),
            SpeedDialChild(
              child: const Icon(Icons.lightbulb),
              label: 'Create thinks to do',
              backgroundColor: Colors.grey,
              onTap: () {/* Do something */},
            ),
            SpeedDialChild(
              child: const Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey,
              onTap: () {/* Do something */},
            ),
          ]),
    );
  }
}
