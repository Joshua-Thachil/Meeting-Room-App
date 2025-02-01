import 'package:calendar_view/calendar_view.dart';

// Backend: Class that Contains Event data that will be displayed on the calendar
class EventModel {

  static List<CalendarEventData> events = [
    CalendarEventData(
      title: "Test Event 1",
      date: DateTime.now(),
      startTime: DateTime(2025, 1, 30, 13),
      endTime: DateTime(2025, 1, 30, 14),

    ),
    CalendarEventData(
      title: "Test Event 2",
      date: DateTime(2025, 1, 29),
      startTime: DateTime(2025, 1, 29, 10),
      endTime: DateTime(2025, 1, 29, 13),
    )
  ];
}

