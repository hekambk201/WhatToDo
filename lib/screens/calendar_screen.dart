import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/events.dart';
import 'calendar-pages/add_event.dart';
import 'calendar-pages/events_screen.dart';
import '../constants.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // List _selectedEvents;
  CalendarController _calendarController;
  var _selectedDay = DateTime.now();

  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 10, color: kPrimaryColor)),
              child: FutureBuilder(
                  future: Provider.of<Events>(context, listen: false)
                      .fetchAndSetEvents(),
                  builder: (context, snapshot) => snapshot.data == null
                      ? SpinKitPulse(
                          color: kPrimaryColor,
                          size: MediaQuery.of(context).size.width / 15,
                        )
                      : TableCalendar(
                          locale: 'en_US',
                          calendarController: _calendarController,
                          events: Provider.of<Events>(context).allEvents,
                          rowHeight: 50,
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          weekendDays: [
                            DateTime.friday,
                            DateTime.saturday,
                          ],
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(color: kPrimaryColor)),
                          onDaySelected: (day, _) {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                          onDayLongPressed: (day, events) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsScreen(day)));
                          },
                          initialSelectedDay: DateTime.now(),
                          calendarStyle: CalendarStyle(
                            outsideWeekendStyle:
                                TextStyle(color: kSecondaryColor),
                            markersAlignment: Alignment.topCenter,
                            markersColor: kPrimaryColor,
                            weekendStyle: TextStyle(color: kPrimaryColor),
                            highlightToday: true,
                            canEventMarkersOverflow: false,
                          ),
                          builders: buildCalendarBuilders(),
                        )),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<Events>(
                builder: (context, events, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'You have ',
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                        Text(
                          '${events.findEventsByDay(_selectedDay).length} ',
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'event(s).',
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: MediaQuery.of(context).size.width / 25),
                        ),
                      ],
                    )),
            SizedBox(
              height: 40,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEvent(_selectedDay)))
                    .then((value) {
                  if (value == 'success') {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: true,
                      dialogType: DialogType.SUCCES,
                      animType: AnimType.SCALE,
                      title: 'Event Added!',
                      desc: 'Event was added successfully!',
                    ).show();
                  } else if (value == 'error') {
                    AwesomeDialog(
                      context: context,
                      headerAnimationLoop: true,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.SCALE,
                      title: 'OOPS',
                      desc:
                          'An error has occurred while trying to add the Event, please try again later',
                    ).show();
                  }
                });
              },
              backgroundColor: kPrimaryColor,
              label: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle_outline,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text('Event', style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CalendarBuilders buildCalendarBuilders() {
    return CalendarBuilders(
      markersBuilder: (context, date, events, holidays) {
        final children = <Widget>[];

        if (events.isNotEmpty) {
          children.add(
            Positioned(
              right: 1,
              bottom: 1,
              child: _buildEventsMarker(date, events),
            ),
          );
        }

        if (holidays.isNotEmpty) {
          children.add(
            Positioned(
              right: 0,
              top: -2,
              child: _buildHolidaysMarker(),
            ),
          );
        }

        return children;
      },
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? kLightColor
            : kSecondaryColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: kAccentColor,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      FontAwesomeIcons.gift,
      size: 15.0,
      color: kPrimaryColor,
    );
  }
}
