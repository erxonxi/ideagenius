import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/note.dart';

class NotesStorage {
  static Future<List<Note>> getNotes() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    final notes = json.decode(contents) as List;
    return notes.map((note) => Note.fromMap(note)).toList();
  }

  static Future<void> addNote(Note note) async {
    final file = await _localFile;
    final notes = await getNotes();
    notes.add(note);
    final notesAsMaps = notes.map((note) => note.toMap()).toList();
    await file.writeAsString(json.encode(notesAsMaps));
  }

  static Future<void> deleteNote(Note note) async {
    final file = await _localFile;
    final notes = await getNotes();
    notes.removeWhere((n) =>
        n.title == note.title && n.date == note.date && n.time == note.time);
    final notesAsMaps = notes.map((note) => note.toMap()).toList();
    await file.writeAsString(json.encode(notesAsMaps));
  }

  static Future<void> updateNote(Note newNote) async {
    final file = await _localFile;
    final notes = await getNotes();
    notes.removeWhere((n) =>
        n.title == newNote.title &&
        n.date == newNote.date &&
        n.time == newNote.time);
    notes.add(newNote);
    final notesAsMaps = notes.map((note) => note.toMap()).toList();
    await file.writeAsString(json.encode(notesAsMaps));
  }

  static Future<File> get _localFile async {
    final path = await _localPath;

    final file = File('$path/notes.json');
    if (!await file.exists()) {
      await file.create();
      file.writeAsString("[]");
    }

    return file;
  }

  static Future<String> get _localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); // from path_provider package
    return directory.path;
  }
}
