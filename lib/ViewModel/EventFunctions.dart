import 'package:calendar_view/calendar_view.dart';

class EventFunctions {

  static void addEvents(List<CalendarEventData> events, EventController controller){
    controller.addAll(events);
  }

}