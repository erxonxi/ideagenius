import 'package:flutter/material.dart';

import '../../../components/note_card.dart';
import '../../../utils/notes_storage.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.notes,
    required this.onNoteDelete,
    required this.onNoteTap,
  });

  final List<Note> notes;
  final Function(Note p1) onNoteDelete;
  final Function(Note p1) onNoteTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget noteList;

        if (constraints.maxWidth < 600) {
          noteList = ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                onDelete: () => onNoteDelete(note),
                onTap: () => onNoteTap(note),
                color: Color(int.parse(note.color)),
                title: note.title,
                content: note.content,
                date: note.date,
              );
            },
          );
        } else {
          int crossAxisCount = 2;

          if (constraints.maxWidth > 900) {
            crossAxisCount = 3;
          }

          noteList = GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 0.7
                      : 1.5,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                onDelete: () => onNoteDelete(note),
                onTap: () => onNoteTap(note),
                color: Color(int.parse(note.color)),
                title: note.title,
                content: note.content,
                date: note.date,
              );
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: noteList,
        );
      },
    );
  }
}
