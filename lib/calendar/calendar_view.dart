import 'package:calendar_widget_creation/calendar/add_event_view.dart';
import 'package:calendar_widget_creation/calendar/calendar_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class CalendarViewForMyApp extends StatefulWidget {
  const CalendarViewForMyApp({super.key});

  @override
  State<CalendarViewForMyApp> createState() => _CalendarViewForMyAppState();
}

class _CalendarViewForMyAppState extends State<CalendarViewForMyApp> {
  CalendarView currentBody = CalendarView.month;
  CalendarController calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 53, 137, 215),
          tooltip: 'Add',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventCreator(),
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        appBar: AppBar(
          title: const Text("Calendar"),
        ),
        body: CalendarWidget(
          currentBody: currentBody,
          calendarController: calendarController,
        ),
      ),
    );
  }
}
