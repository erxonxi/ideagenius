import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideagenis/blocs/notes/notes_bloc.dart';
import 'package:ideagenis/screens/note_screen.dart';

import '../../../components/note_card.dart';
import '../../../models/note.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(NotesLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            Widget noteList;

            if (constraints.maxWidth < 600) {
              noteList = ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteCard(
                    onDelete: () => _onNoteDelete(note),
                    onTap: () => _onNoteTap(note),
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
                padding: const EdgeInsets.all(8.0),
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
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteCard(
                    onDelete: () => _onNoteDelete(note),
                    onTap: () => _onNoteTap(note),
                    color: Color(int.parse(note.color)),
                    title: note.title,
                    content: note.content,
                    date: note.date,
                  );
                },
              );
            }

            return noteList;
          },
        );
      },
    );
  }

  _onNoteTap(Note note) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: NoteScreen(note: note),
          );
        },
      ),
    );
  }

  _onNoteDelete(Note note) {
    context.read<NotesBloc>().add(NotesDelete(note));
  }
}
