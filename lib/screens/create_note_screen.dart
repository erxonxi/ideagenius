// Create Note Page Widget
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ideagenis/blocs/notes/notes_bloc.dart';

import '../models/note.dart';
import '../utils/note_colors.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final QuillController _controller = QuillController.basic();
  final _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  Note note = Note(
                    title: _title.text,
                    content:
                        json.encode(_controller.document.toDelta().toJson()),
                    color: randomNoteColor().value.toString(),
                    date: DateTime.now().toString(),
                    time: DateTime.now().toString(),
                  );

                  context.read<NotesBloc>().add(NotesAdd(note));

                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _title,
                        decoration: const InputDecoration(
                          labelText: "Note Title",
                        ),
                      ),
                      const Divider(),
                      QuillToolbar.basic(controller: _controller),
                    ],
                  )),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: QuillEditor.basic(
                    controller: _controller,
                    readOnly: false,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
