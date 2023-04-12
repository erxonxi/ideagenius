import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/home/views/summary_view.dart';
import '../../../blocs/tabs/tabs_bloc.dart';
import '../../../utils/notes_storage.dart';
import '../views/home_view.dart';
import '../views/todoes_view.dart';

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
            HomeView(
                notes: notes, onNoteDelete: onNoteDelete, onNoteTap: onNoteTap),
            const ToDoesView(),
            // Settings
            const SummaryView()
          ],
        );
      },
    );
  }
}
