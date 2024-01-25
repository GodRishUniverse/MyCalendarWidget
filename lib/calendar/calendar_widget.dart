import 'package:calendar_widget_creation/calendar/event_data_source.dart';
import 'package:calendar_widget_creation/calendar/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    Key? key,
    required this.currentBody,
    required this.calendarController,
  }) : super(key: key);

  final CalendarView currentBody;
  final CalendarController calendarController;

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: currentBody,
      initialSelectedDate: DateTime.now(),
      dataSource: EventDataSource(events),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        showAgenda: true,
      ),
      controller: calendarController,
    );
  }
}
