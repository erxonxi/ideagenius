import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final Color color;
  final String content;
  final String date;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const NoteCard({
    Key? key,
    required this.title,
    required this.color,
    required this.content,
    required this.date,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: color,
        elevation: 0,
        // full width
        child: SizedBox(
          width: double.infinity,
          // background color
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
