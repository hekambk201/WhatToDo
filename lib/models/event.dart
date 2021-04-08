import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final TimeOfDay startsAt;
  final TimeOfDay endsAt;
  Event({
    this.id,
    this.title,
    this.startsAt,
    this.endsAt,
  });
}
