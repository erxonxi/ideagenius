import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ideagenis/screens/home/components/config_view.dart';

import '../../../blocs/tabs/tabs_bloc.dart';
import '../../../components/note_card.dart';
import '../../../utils/config_storage.dart';
import '../../../utils/notes_storage.dart';

class HomeTabsView extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onNoteDelete;
  final Function(Note) onNoteTap;
  final Config config;

  const HomeTabsView({
    super.key,
    required this.notes,
    required this.onNoteDelete,
    required this.onNoteTap,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, int>(
      builder: (context, currentIndex) {
        return IndexedStack(
          index: currentIndex,
          children: [
            ListView.builder(
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
            ),
            const Center(
              child: Text("Todo"),
            ),
            // Settings
            ConfigView(config: config)
          ],
        );
      },
    );
  }
}
