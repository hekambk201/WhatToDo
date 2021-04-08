import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class Events with ChangeNotifier {
  Map<DateTime, List<Event>> _events = {};
  final String authToken;
  final String userId;
  Events(this.authToken, this.userId, this._events);

  Future<Map<DateTime, List<Event>>> fetchAndSetEvents() async {
    final url =
        'https://what-to-do-f434a.firebaseio.com/userEvents/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final Map<DateTime, List<Event>> loadedEvents = <DateTime, List<Event>>{};

      final extractedData = json.decode(response.body);
      if (extractedData == null) return {};
      extractedData.forEach((dateString, events) {
        loadedEvents.putIfAbsent(DateTime.parse(dateString), () {
          List<Event> es = [];
          Map<String, dynamic>.from(events).forEach((eventId, eventDataMap) {
            Event e = new Event(
                id: eventId,
                title: eventDataMap['title'],
                startsAt: TimeOfDay(
                    hour: int.parse(eventDataMap['startsAt'].split(':')[0]),
                    minute: int.parse(eventDataMap['startsAt'].split(':')[1])),
                endsAt: TimeOfDay(
                    hour: int.parse(eventDataMap['endsAt'].split(':')[0]),
                    minute: int.parse(eventDataMap['endsAt'].split(':')[1])));
            es.add(e);
          });
          return es;
        });
      });
      _events = loadedEvents;
      notifyListeners();
    } catch (error) {
      print(error);
    }
    return _events;
  }

  Map<DateTime, List<Event>> get allEvents {
    return _events == null ? <DateTime, List<Event>>{} : _events;
  }

  List<Event> get allEventsList {
    List<Event> events = [];
    _events.values.forEach((eventList) {
      events.addAll(eventList);
    });
    return events;
  }

  List<Event> findEventsByDay(DateTime day) {
    DateTime dayFormatted = DateTime(day.year, day.month, day.day);
    return _events.containsKey(dayFormatted)
        ? _events[dayFormatted]
        : <Event>[];
  }

  Future<void> addEvent(DateTime day, Event event) async {
    DateTime dayFormatted = DateTime(day.year, day.month, day.day);
    String dayForUrl = dayFormatted.toIso8601String().split('T')[0];
    final url =
        'https://what-to-do-f434a.firebaseio.com/userEvents/$userId/$dayForUrl.json?auth=$authToken';

    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': event.title,
            'startsAt': '${event.startsAt.hour}:${event.startsAt.minute}',
            'endsAt': '${event.endsAt.hour}:${event.endsAt.minute}'
          }));

      final newEvent = Event(
          id: jsonDecode(response.body)['name'],
          title: event.title,
          startsAt: event.startsAt,
          endsAt: event.endsAt);
      _events.containsKey(dayFormatted)
          ? _events[dayFormatted].add(newEvent)
          : _events.putIfAbsent(dayFormatted, () => [newEvent]);
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> editEvent(String eventId, DateTime day, Event newEvent) async {
    DateTime dayFormatted = DateTime(day.year, day.month, day.day);
    String dayForUrl = dayFormatted.toIso8601String().split('T')[0];
    final eventIndex =
        _events[dayFormatted].indexWhere((event) => event.id == eventId);
    if (eventIndex >= 0) {
      final url =
          'https://what-to-do-f434a.firebaseio.com/userEvents/$userId/$dayForUrl/$eventId.json?auth=$authToken';
      try {
        await http.patch(url,
            body: jsonEncode({
              'title': newEvent.title,
              'startsAt':
                  '${newEvent.startsAt.hour}:${newEvent.startsAt.minute}',
              'endsAt': '${newEvent.endsAt.hour}:${newEvent.endsAt.minute}'
            }));
        _events[dayFormatted][eventIndex] = newEvent;
        notifyListeners();
      } catch (error) {
        print('error from provider is $error');
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteEvent(String eventId, DateTime day) async {
    DateTime dayFormatted = DateTime(day.year, day.month, day.day);
    String dayForUrl = dayFormatted.toIso8601String().split('T')[0];
    final url =
        'https://what-to-do-f434a.firebaseio.com/userEvents/$userId/$dayForUrl/$eventId.json?auth=$authToken';
    final existingEventIndex =
        _events[dayFormatted].indexWhere((event) => event.id == eventId);
    var existingEvent = _events[dayFormatted][existingEventIndex];
    _events[dayFormatted].removeAt(existingEventIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _events[dayFormatted].insert(existingEventIndex, existingEvent);
        notifyListeners();
      }
    } catch (error) {
      _events[dayFormatted].insert(existingEventIndex, existingEvent);
      notifyListeners();
      throw error;
    }

    existingEvent = null;
  }
}
