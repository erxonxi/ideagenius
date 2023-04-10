import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ideagenis/pages/config_view.dart';
import 'package:yaru/yaru.dart';

import '../main.dart';
import '../utils/config_storage.dart';
import '../utils/note_colors.dart';
import '../utils/notes_storage.dart';
import '../utils/openai_service.dart';

class SpeedDialAddTask extends StatefulWidget {
  final Function onTaskCreated;

  const SpeedDialAddTask({
    super.key,
    required this.onTaskCreated,
  });

  @override
  State<SpeedDialAddTask> createState() => _SpeedDialAddTaskState();
}

class _SpeedDialAddTaskState extends State<SpeedDialAddTask> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
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
          onTap: _showCreateThinkDialog,
        ),
        SpeedDialChild(
          child: const Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Colors.grey,
          onTap: _visitConfigPage,
        ),
      ],
    );
  }

  Future<void> _visitCreateNotePage() async {
    final note = await Navigator.pushNamed(context, "/create-note") as Note?;
    if (note != null) {
      await NotesStorage.addNote(note);
      widget.onTaskCreated();
    }
  }

  final TextEditingController _thinkController = TextEditingController();

  Future<void> _showCreateThinkDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create thinks to do'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _thinkController,
                  decoration: const InputDecoration(
                    labelText: "Think",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createTodoesOfThink();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createTodoesOfThink() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final think = _thinkController.text;
    final todoes = await createTodoesOfThink(apiKey, think);
    final note = Note(
      title: think,
      content: todoes,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    widget.onTaskCreated();
  }

  Future<void> _visitConfigPage() async {
    Config config = await ConfigStorage.getConfig();

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YaruTheme(
          data: AppTheme.of(context),
          child: ConfigViewPage(config: config),
        ),
      ),
    );
  }
}
