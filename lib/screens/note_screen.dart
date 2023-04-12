import 'package:flutter/material.dart';

import '../utils/notes_storage.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.content,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Date: ${widget.note.date}\nTime: ${widget.note.time}",
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
