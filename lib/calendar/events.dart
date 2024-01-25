import 'package:flutter/material.dart';

class Events {
  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String? desc;

  Events({
    required this.eventName,
    required this.from,
    required this.to,
    required this.desc,
    this.isAllDay = false,
    this.background = Colors.blue,
  });
}
