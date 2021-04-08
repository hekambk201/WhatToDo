import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/notes.dart';
import './notes-pages/add-note.dart';
import './notes-pages/edit-note.dart';
import './notes-pages/note-detail.dart';
import '../constants.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      await Provider.of<Notes>(context).fetchAndSetNotes();
    }

    return Scaffold(
      body: FutureBuilder(
          future: Provider.of<Notes>(context, listen: false).fetchAndSetNotes(),
          builder: (context, snapshot) {
            final _notes = snapshot.data;
            return _notes == null
                ? SpinKitSquareCircle(
                    color: kPrimaryColor,
                    size: MediaQuery.of(context).size.width / 15,
                  )
                : Consumer<Notes>(
                    builder: (context, value, _) {
                      var notes = value.allNotes;
                      return notes.length == 0
                          ? Center(
                              child:
                                  Image.asset('assets/images/empty-notes.png'),
                            )
                          : RefreshIndicator(
                              onRefresh: () async => value.fetchAndSetNotes(),
                              child: GridView.builder(
                                itemCount: notes.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) => Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/note.png'),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: AutoSizeText(
                                                notes[index].title,
                                                style: TextStyle(
                                                    color: kAccentColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: Text(
                                              notes[index].body,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: kAccentColor,
                                              ),
                                              maxLines: 4,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    color: kAccentColor,
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                NoteDetail(
                                                                    notes[
                                                                        index]),
                                                          ))),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: kLightColor,
                                                  ),
                                                  onPressed: () async =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditNote(notes[
                                                                    index]),
                                                          )).then((value) {
                                                        if (value ==
                                                            'success') {
                                                          AwesomeDialog(
                                                            context: context,
                                                            headerAnimationLoop:
                                                                true,
                                                            dialogType:
                                                                DialogType.INFO,
                                                            animType: AnimType
                                                                .TOPSLIDE,
                                                            title: 'Edited',
                                                            desc:
                                                                'Note edited successfully',
                                                          ).show();
                                                          _refresh();
                                                        } else if (value ==
                                                            'error') {
                                                          AwesomeDialog(
                                                            context: context,
                                                            headerAnimationLoop:
                                                                true,
                                                            dialogType:
                                                                DialogType
                                                                    .ERROR,
                                                            animType: AnimType
                                                                .TOPSLIDE,
                                                            title:
                                                                'Unsuccessful!',
                                                            desc:
                                                                'An error has occurred while updating your note\'s info. ',
                                                          ).show();
                                                        }
                                                      })),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () async {
                                                    await AwesomeDialog(
                                                        context: context,
                                                        headerAnimationLoop:
                                                            false,
                                                        dialogType:
                                                            DialogType.WARNING,
                                                        animType:
                                                            AnimType.TOPSLIDE,
                                                        btnOkText: 'Yes',
                                                        btnCancelText: 'No',
                                                        title: 'Are you sure?',
                                                        desc:
                                                            'Are you sure that you want to delete this Note?',
                                                        btnCancelOnPress: () {},
                                                        btnOkOnPress: () async {
                                                          try {
                                                            await Provider.of<
                                                                        Notes>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteNote(
                                                                    notes[index]
                                                                        .id);
                                                          } catch (error) {
                                                            return 'error';
                                                          }

                                                          return 'success';
                                                        }).show().then((value) {
                                                      _refresh();
                                                    });
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNote(),
            )).then((value) async {
          if (value == 'success') {
            _refresh();
            AwesomeDialog(
              context: context,
              headerAnimationLoop: true,
              dialogType: DialogType.SUCCES,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Success!',
              desc: 'Note was added successfully!',
            ).show();
          } else if (value == 'error') {
            AwesomeDialog(
              context: context,
              headerAnimationLoop: true,
              dialogType: DialogType.ERROR,
              animType: AnimType.TOPSLIDE,
              title: 'Error!',
              desc: 'An error has occurred while trying to add your new note',
            ).show();
          }
        }),
        child: Icon(Icons.note_add),
      ),
    );
  }
}
