import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note.dart';
import '../../providers/notes.dart';

import '../../constants.dart';

class EditNote extends StatefulWidget {
  final Note note;
  EditNote(this.note);
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final formKey = GlobalKey<FormState>();
  final _bodyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String _titleValue = widget.note.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: widget.note.title,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_bodyFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Title can\'t be empty';
                  } else
                    return null;
                },
                onSaved: (newValue) {
                  _titleValue = newValue;
                },
              ),
              TextFormField(
                initialValue: widget.note.body,
                onSaved: (newValue) async {
                  try {
                    await Provider.of<Notes>(context, listen: false).editNote(
                        widget.note.id,
                        Note(title: _titleValue, body: newValue));
                    Navigator.pop(context, 'success');
                  } catch (error) {
                    Navigator.pop(context, 'error');
                  }
                },
                focusNode: _bodyFocusNode,
                decoration: InputDecoration(labelText: 'Body'),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Body can\'t be empty';
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton.extended(
                  backgroundColor: kPrimaryColor,
                  label: Row(
                    children: <Widget>[
                      Icon(
                        Icons.save_alt,
                        size: 22,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Save changes')
                    ],
                  ),
                  onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }

  @override
  void dispose() {
    _bodyFocusNode.dispose();
    super.dispose();
  }
}
