import 'package:floor/floor.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

@entity
class Events{ // Events Table to store event data in sqlite db

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? title;
  String? startTime;
  String? endTime;

  Events(this.id, this.title, this.startTime, this.endTime);
}

class CustomCalendarEventData extends CalendarEventData {
  final String bookedBy;
  final CalendarEventData? event;

  CustomCalendarEventData({
    required String title,
    required DateTime date,
    String? description,
    this.event,
    Color color = Colors.blue,
    DateTime? startTime,
    DateTime? endTime,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    RecurrenceSettings? recurrenceSettings,
    DateTime? endDate,
    required this.bookedBy,
  }) : super(
    title: title,
    date: date,
    description: description,
    event: event,
    color: color,
    startTime: startTime,
    endTime: endTime,
    titleStyle: titleStyle,
    descriptionStyle: descriptionStyle,
    recurrenceSettings: recurrenceSettings,
    endDate: endDate,
  );
}