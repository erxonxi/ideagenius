// Create Note Page Widget
import 'package:flutter/material.dart';

import '../utils/note_colors.dart';
import '../utils/notes_storage.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _content = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Title"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a title";
                }
                return null;
              },
              onSaved: (value) {
                _title = value ?? "";
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 50,
              decoration: const InputDecoration(labelText: "Content"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a content";
                }
                return null;
              },
              onSaved: (value) {
                _content = value ?? "";
              },
            ),
            const SizedBox(height: 16.0),
            FilledButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  final note = Note(
                    title: _title,
                    content: _content,
                    color: randomNoteColor().value.toString(),
                    date: DateTime.now().toString(),
                    time: DateTime.now().toString(),
                  );
                  Navigator.of(context).pop(note);
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}