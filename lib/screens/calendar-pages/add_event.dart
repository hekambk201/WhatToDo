import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/events.dart';
import '../../constants.dart';

class AddEvent extends StatefulWidget {
  final DateTime day;

  AddEvent(this.day);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final formKey = GlobalKey<FormState>();

  TimeOfDay start = TimeOfDay.now();

  TimeOfDay end = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Event'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              child: Text(
                'Date: ${widget.day.day} / ${widget.day.month} / ${widget.day.year}',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
            ),
            Center(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              validator: (value) {
                                return value == null || value == ''
                                    ? 'Title can not be null'
                                    : null;
                              },
                              autofocus: false,
                              decoration:
                                  InputDecoration(labelText: 'Event Name'),
                              onSaved: (input) async {
                                try {
                                  await Provider.of<Events>(context,
                                          listen: false)
                                      .addEvent(
                                          widget.day,
                                          new Event(
                                              title: input,
                                              startsAt: start,
                                              endsAt: end));
                                  Navigator.pop(context, 'success');
                                } catch (error) {
                                  Navigator.pop(context, 'error');
                                }
                              },
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Event Starts at:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: kSecondaryColor),
                                ),
                                Text(
                                  start.format(context),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22,
                                      color: kPrimaryColor),
                                ),
                                SizedBox(width: 10),
                                RaisedButton.icon(
                                  color: kLightColor,
                                  elevation: 10,
                                  textColor: kAccentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () async {
                                    var startPickedTime = await showTimePicker(
                                        context: context, initialTime: start);
                                    start = startPickedTime == null
                                        ? start
                                        : startPickedTime;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.clock,
                                    size:
                                        MediaQuery.of(context).size.width / 22,
                                  ),
                                  label: Text(
                                    'Pick Time',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Event Ends at:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              25,
                                      color: kSecondaryColor),
                                ),
                                Text(
                                  end.format(context),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              22,
                                      color: kPrimaryColor),
                                ),
                                SizedBox(width: 10),
                                RaisedButton.icon(
                                  color: kLightColor,
                                  elevation: 10,
                                  textColor: kAccentColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () async {
                                    var endPickedTime = await showTimePicker(
                                        context: context, initialTime: end);
                                    end = endPickedTime == null
                                        ? end
                                        : endPickedTime;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.clock,
                                    size:
                                        MediaQuery.of(context).size.width / 22,
                                  ),
                                  label: Text(
                                    'Pick Time',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                25),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: kPrimaryColor,
                        label: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.calendarPlus,
                              size: 22,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Add Event')
                          ],
                        ),
                        onPressed: _submit,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }
}
