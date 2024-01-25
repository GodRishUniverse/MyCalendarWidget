import 'dart:ui';

import 'package:calendar_widget_creation/calendar/events.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Events> appointments) {
    this.appointments = appointments;
  }

  Events getEvent(int index) => appointments![index] as Events;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).eventName;

  @override
  Color getColor(int index) => getEvent(index).background;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;
}
