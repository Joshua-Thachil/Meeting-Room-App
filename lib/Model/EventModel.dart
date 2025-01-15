import 'package:calendar_view/calendar_view.dart';

// Backend: Class that Contains Event data that will be displayed on the calendar
class EventModel {
  List<CalendarEventData> events = [
    CalendarEventData(
      title: "Test Event 1",
      date: DateTime.now(),
      startTime: DateTime(2025, 1, 15, 13),
      endTime: DateTime(2025, 1, 15, 14),
    ),
    CalendarEventData(
      title: "Test Event 2",
      date: DateTime(2025, 1, 16),
      startTime: DateTime(2025, 1, 16, 10),
      endTime: DateTime(2025, 1, 16, 13),
    )
  ];
}
