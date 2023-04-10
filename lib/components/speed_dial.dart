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
  final TextEditingController _thinkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.window_rounded,
      overlayColor: Colors.black,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.add_rounded),
          label: 'Add',
          backgroundColor: Colors.grey,
          onTap: _visitCreateNotePage,
        ),
        SpeedDialChild(
          child: const Icon(Icons.lightbulb_rounded),
          label: 'Create todos',
          backgroundColor: Colors.grey,
          onTap: _showCreateThinkDialog,
        ),
        SpeedDialChild(
          child: const Icon(Icons.read_more_rounded),
          label: 'Summarize',
          backgroundColor: Colors.grey,
          onTap: _showSumarizeDialog,
        ),
        SpeedDialChild(
          child: const Icon(Icons.question_mark_rounded),
          label: 'Questions',
          backgroundColor: Colors.grey,
          onTap: _showQuestionsDialog,
        ),
        SpeedDialChild(
          child: const Icon(Icons.settings_rounded),
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

  Future<void> _showSumarizeDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Summarize'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _thinkController,
                  minLines: 4,
                  maxLines: 64,
                  decoration: const InputDecoration(
                    labelText: "Content",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createSumarize();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createSumarize() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final think = _thinkController.text;
    _thinkController.clear();
    final res = await createSummary(apiKey, think);
    final note = Note(
      title: "Summarize",
      content: res,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    widget.onTaskCreated();
  }

  // same as _showSumarizeDialog and _createSumarize for _showQuestionsDialog and _createQuestions using createQuestions of openai_service.dart
  Future<void> _showQuestionsDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Questions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _thinkController,
                  minLines: 4,
                  maxLines: 64,
                  decoration: const InputDecoration(
                    labelText: "Content",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createQuestions();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createQuestions() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final content = _thinkController.text;
    _thinkController.clear();
    final res = await createQuestions(apiKey, content);
    final note = Note(
      title: "Questions",
      content: res,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    widget.onTaskCreated();
  }

  Future<void> _showCreateThinkDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create todos from think'),
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
    _thinkController.clear();
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
