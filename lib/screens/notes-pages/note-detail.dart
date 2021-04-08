import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/note.dart';

class NoteDetail extends StatelessWidget {
  final Note note;
  NoteDetail(this.note);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Text(
                note.body,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
