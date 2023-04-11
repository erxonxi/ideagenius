import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideagenis/screens/home/components/config_view.dart';

import '../../../blocs/tabs/tabs_bloc.dart';
import '../../../components/note_card.dart';
import '../../../utils/notes_storage.dart';

class HomeTabsView extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteDelete;
  final Function(Note) onNoteTap;

  const HomeTabsView({
    super.key,
    required this.notes,
    required this.onNoteDelete,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, int>(
      builder: (context, currentIndex) {
        return IndexedStack(
          index: currentIndex,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                Widget noteList;

                if (constraints.maxWidth < 600) {
                  noteList = Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: notes.map((note) {
                      return NoteCard(
                        onDelete: () => onNoteDelete(note),
                        onTap: () => onNoteTap(note),
                        color: Color(int.parse(note.color)),
                        title: note.title,
                        content: note.content,
                        date: note.date,
                      );
                    }).toList(),
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
                      childAspectRatio: MediaQuery.of(context).orientation ==
                              Orientation.portrait
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
            ),
            const Center(
              child: Text("Todo"),
            ),
            // Settings
            const ConfigView()
          ],
        );
      },
    );
  }
}
