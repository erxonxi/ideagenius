import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:ideagenis/blocs/notes/notes_bloc.dart';

import '../utils/notes_storage.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final quill.QuillController _controller = quill.QuillController.basic();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller.document = quill.Document.fromJson(
      quill.Delta.fromJson(json.decode(widget.note.content)).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.note.title),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (_isEditing) {
                    widget.note.content =
                        json.encode(_controller.document.toDelta().toJson());
                    context.read<NotesBloc>().add(NotesUpdate(widget.note));
                  }

                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () {
                  context.read<NotesBloc>().add(NotesDelete(widget.note));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isEditing
                    ? quill.QuillToolbar.basic(controller: _controller)
                    : Container(),
                const Divider(),
                quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: !_isEditing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
