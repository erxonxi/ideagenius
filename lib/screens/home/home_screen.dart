import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/config_screen.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../components/speed_dial.dart';
import '../../utils/notes_storage.dart';
import '../note_screen.dart';
import 'components/home_bottom_navigator.dart';
import 'components/home_drawer.dart';
import 'components/home_tabs_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTabletOrDesktop = screenWidth >= 600;

    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("IdeaGenius"),
            actions: [
              IconButton(
                  onPressed: _visitConfigPage,
                  icon: const Icon(Icons.settings_rounded)),
              Switch(
                value: state == ThemeMode.dark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ThemeChangedEvent(
                        themeMode: value ? ThemeMode.dark : ThemeMode.light,
                      ));
                },
              ),
            ],
          ),
          drawer: isTabletOrDesktop ? const HomeDrawer() : null,
          body: HomeTabsView(
            notes: _notes,
            onNoteDelete: _deleteNote,
            onNoteTap: _visitNoteViewPage,
          ),
          bottomNavigationBar:
              isTabletOrDesktop ? null : const HomeBottomNavigator(),
          floatingActionButton: SpeedDialAddTask(
            onTaskCreated: _loadNotes,
          ),
        );
      },
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
        builder: (context) => NoteScreen(note: note),
      ),
    );
  }

  void _visitConfigPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfigScreen(),
      ),
    );
  }

  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }
}
