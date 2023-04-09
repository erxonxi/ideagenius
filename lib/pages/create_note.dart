// Create Note Page Widget
import 'package:flutter/material.dart';

import '../components/note_card.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
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
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Enter the title",
              ),
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
              decoration: const InputDecoration(
                labelText: "Content",
                hintText: "Enter the content",
              ),
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
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  final note = NoteCard(
                    color: Colors.grey.shade200,
                    title: _title,
                    content: _content,
                    date: DateTime.now().toString(),
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
