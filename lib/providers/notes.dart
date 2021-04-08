import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [];
  final String authToken;
  final String userId;
  Notes(
    this.authToken,
    this.userId,
    this._notes,
  );
  List<Note> get allNotes => _notes;

  Future<List<Note>> fetchAndSetNotes() async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userNotes/$userId.json?auth=$authToken';
    try {
      List<Note> loadedNotes = [];
      final response = await http.get(url);
      final fetchedData = jsonDecode(response.body);

      fetchedData != null
          ? fetchedData.forEach((noteId, noteDataMap) {
              loadedNotes.add(Note(
                  id: noteId,
                  title: noteDataMap['title'],
                  body: noteDataMap['body']));
            })
          : loadedNotes = [];
      _notes = loadedNotes;
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return allNotes;
  }

  Future<void> addNote(Note newNote) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userNotes/$userId.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: jsonEncode({'title': newNote.title, 'body': newNote.body}));
      print(response.body);
      final newNoteId = jsonDecode(response.body)['name'];
      final addedNote =
          Note(id: newNoteId, title: newNote.title, body: newNote.body);
      if (_notes == null) {
        _notes = [];
        _notes.add(addedNote);
        notifyListeners();
      } else {
        _notes.add(addedNote);
        notifyListeners();
      }
    } catch (error) {
      print('error is $error');
      throw error;
    }
    notifyListeners();
  }

  Future<void> editNote(String noteId, Note newNote) async {
    final noteIndex = _notes.indexWhere((note) => note.id == noteId);
    if (noteIndex >= 0) {
      final url =
          'https://what-to-do-f434a.firebaseio.com/userNotes/$userId/$noteId.json?auth=$authToken';
      try {
        await http.patch(url,
            body: jsonEncode({'title': newNote.title, 'body': newNote.body}));
        _notes[noteIndex] = newNote;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteNote(String noteId) async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userNotes/$userId/$noteId.json?auth=$authToken';

    final existingNoteIndex = _notes.indexWhere((note) => note.id == noteId);
    var existingNote = _notes[existingNoteIndex];
    _notes.removeAt(existingNoteIndex);
    notifyListeners();

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _notes.insert(existingNoteIndex, existingNote);
        notifyListeners();
      }
    } catch (error) {
      print(error);
      _notes.insert(existingNoteIndex, existingNote);
      notifyListeners();
      throw error;
    }

    existingNote = null;
  }
}
