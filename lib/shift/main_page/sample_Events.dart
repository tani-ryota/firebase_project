import 'package:firebase_project/shift/cell_calendar.dart';
//import 'package:firebase_project/shift/controllers/cell_calendar_page.dart';
import 'package:flutter/material.dart';

List<CalendarEvent> sampleEvents() {
  final today = DateTime.now();
  const eventTextStyle = TextStyle(
    fontSize: 9,
    color: Color.fromARGB(255, 56, 51, 51),
  );
  final sampleEvents = [
    CalendarEvent(
      eventName: "バイト",
      eventDate: today.add(const Duration()),
      eventBackgroundColor: const Color.fromARGB(255, 54, 222, 244),
      eventTextStyle: eventTextStyle,
    ),
  ];
  return sampleEvents;
}
