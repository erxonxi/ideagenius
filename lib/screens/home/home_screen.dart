import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/tabs/tabs_bloc.dart';
import '../../blocs/theme/theme_bloc.dart';
import '../../components/speed_dial.dart';
import '../../utils/config_storage.dart';
import '../../utils/notes_storage.dart';
import '../note_view.dart';
import 'components/home_bottom_navigator.dart';
import 'components/home_tabs_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  Config _config = Config(openAiKey: "");

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("IdeaGenius"),
            actions: [
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
          body: HomeTabsView(
            notes: _notes,
            onNoteDelete: _deleteNote,
            onNoteTap: _visitNoteViewPage,
            config: _config,
          ),
          bottomNavigationBar: const HomeBottomNavigator(),
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
        builder: (context) => NoteViewPage(note: note),
      ),
    );
  }

  void themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadConfig() async {
    final config = await ConfigStorage.getConfig();
    setState(() {
      _config = config;
    });
  }
}
