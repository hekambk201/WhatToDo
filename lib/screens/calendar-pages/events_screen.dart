import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'edit_event.dart';
import '../../providers/events.dart';
import '../../constants.dart';

class EventsScreen extends StatefulWidget {
  final DateTime day;
  EventsScreen(this.day);
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    var events = Provider.of<Events>(context).findEventsByDay(widget.day);
    Future<void> _refresh() async {
      await Provider.of<Events>(context, listen: false).fetchAndSetEvents();
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Events on ${widget.day.day} / ${widget.day.month} / ${widget.day.year}')),
      body: events.length == 0
          ? Center(
              child: Image.asset(
                'assets/images/empty-event.png',
                height: MediaQuery.of(context).size.height / 2.5,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                itemCount: events.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.blueGrey,
                ),
                itemBuilder: (context, index) => Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.redAccent,
                      icon: Icons.delete,
                      onTap: () async {
                        await AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.TOPSLIDE,
                            btnOkText: 'Yes',
                            btnCancelText: 'No',
                            title: 'Are you sure?',
                            desc:
                                'Are you sure that you want to delete this event?',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () async {
                              try {
                                await Provider.of<Events>(context,
                                        listen: false)
                                    .deleteEvent(events[index].id, widget.day);
                                return 'success';
                              } catch (error) {
                                return 'error';
                              }
                            }).show();
                      },
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: kLightColor,
                      icon: Icons.edit,
                      onTap: () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditEvent(widget.day, events[index])))
                            .then((value) {
                          if (value == 'Successful') {
                            _refresh();
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: true,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Edit Complete!',
                              desc: 'Event was edited successfully!',
                            ).show();
                          } else if (value == 'error') {
                            AwesomeDialog(
                              context: context,
                              headerAnimationLoop: true,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              title: 'Failed!',
                              desc:
                                  'Couldn\'t edit event now, please try again later.',
                            ).show();
                          }
                        });
                      },
                    ),
                  ],
                  child: ListTile(
                    leading: Icon(
                      Icons.event,
                      color: kPrimaryColor,
                    ),
                    title: Text(
                      events[index].title.toString(),
                    ),
                    trailing: Text(
                        '${events[index].startsAt.format(context)} - ${events[index].endsAt.format(context)}'),
                  ),
                ),
              ),
            ),
    );
  }
}
