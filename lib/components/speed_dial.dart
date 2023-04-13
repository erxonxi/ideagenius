import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ideagenis/blocs/notes/notes_bloc.dart';

import '../models/note.dart';
import '../utils/config_storage.dart';
import '../utils/note_colors.dart';
import '../utils/notes_storage.dart';
import '../utils/openai_service.dart';

class SpeedDialAddTask extends StatefulWidget {
  const SpeedDialAddTask({Key? key}) : super(key: key);

  @override
  State<SpeedDialAddTask> createState() => _SpeedDialAddTaskState();
}

class _SpeedDialAddTaskState extends State<SpeedDialAddTask> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
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
              onTap: _showSummarizeDialog,
            ),
            SpeedDialChild(
              child: const Icon(Icons.question_mark_rounded),
              label: 'Questions',
              backgroundColor: Colors.grey,
              onTap: _showQuestionsDialog,
            ),
            SpeedDialChild(
              child: const Icon(Icons.abc_rounded),
              label: 'Custom',
              backgroundColor: Colors.grey,
              onTap: _showCustomPrompt,
            ),
          ],
        );
      },
    );
  }

  void _visitCreateNotePage() {
    Navigator.pushNamed(context, "/create-note").then(
        (note) => {context.read<NotesBloc>().add(NotesAdd(note as Note))});
  }

  Future<void> _showCustomDialog(
      String title, String label, Function() callback
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(8),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _contentController,
                  minLines: 4,
                  maxLines: 64,
                  decoration: InputDecoration(
                    labelText: label,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                callback();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSummarizeDialog() {
    return _showCustomDialog("Summarize", "Content", _createSummarize);
  }

  Future<void> _createSummarize() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final title = _titleController.text;
    final think = _contentController.text;
    _titleController.clear();
    _contentController.clear();
    final res = await createSummary(apiKey, think);
    String resJsonStr = _formatPlainText(res);
    final note = Note(
      title: title,
      content: resJsonStr,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    _onTaskCreated();
  }

  Future<void> _showQuestionsDialog() async {
    return _showCustomDialog("Questions", "Content", _createQuestions);
  }

  Future<void> _createQuestions() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final title = _titleController.text;
    final content = _contentController.text;
    _titleController.clear();
    _contentController.clear();
    final res = await createQuestions(apiKey, content);
    String resJsonStr = _formatPlainText(res);
    final note = Note(
      title: title,
      content: resJsonStr,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    _onTaskCreated();
  }

  Future<void> _showCreateThinkDialog() async {
    return _showCustomDialog("Create todos", "Think", _createToDoesOfThink);
  }

  Future<void> _createToDoesOfThink() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final title = _titleController.text;
    final content = _contentController.text;
    _titleController.clear();
    _contentController.clear();
    final res = await createTodoesOfThink(apiKey, content);
    String resJsonStr = _formatPlainText(res);
    final note = Note(
      title: title,
      content: resJsonStr,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    _onTaskCreated();
  }

  Future<void> _showCustomPrompt() async {
    return _showCustomDialog("Custom Prompt", "Prompt", _createNoteCustomPrompt);
  }

  Future<void> _createNoteCustomPrompt() async {
    final apiKey = (await ConfigStorage.getConfig()).openAiKey;
    final title = _titleController.text;
    final think = _contentController.text;
    _contentController.clear();
    _titleController.clear();
    final res = await promptCompletion(apiKey, think);
    String resJsonStr = _formatPlainText(res);
    final note = Note(
      title: title,
      content: resJsonStr,
      color: randomNoteColor().value.toString(),
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
    );
    await NotesStorage.addNote(note);
    _onTaskCreated();
  }

  void _onTaskCreated() {
    context.read<NotesBloc>().add(NotesLoad());
  }

  String _formatPlainText(String todoes) {
    String todoesJsonStr = "[";
    todoes.split("\n").forEach((element) {
      final fixed = element.trim().replaceAll('"', "'");

      todoesJsonStr += '{"insert":"$fixed\\n"}';

      if (element != todoes.split("\n").last) {
        todoesJsonStr += ",";
      }
    });

    todoesJsonStr += "]";
    return todoesJsonStr;
  }
}
