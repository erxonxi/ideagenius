// utilities to store and retrieve notes from the local file system .json file

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Note {
  String title;
  String content;
  String color;
  String date;
  String time;

  Note({
    required this.title,
    required this.content,
    required this.color,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'color': color,
      'date': date,
      'time': time,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      color: map['color'],
      date: map['date'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}

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
    notes.remove(note);
    await file.writeAsString(json.encode(notes));
  }

  static Future<void> updateNote(Note oldNote, Note newNote) async {
    final file = await _localFile;
    final notes = await getNotes();
    notes.remove(oldNote);
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