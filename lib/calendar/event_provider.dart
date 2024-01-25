import 'package:calendar_widget_creation/calendar/events.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  final List<Events> _events = [];

  List<Events> get events => _events;

  void addEvent(Events event) {
    _events.add(event);
    notifyListeners();
  }
}
