import 'package:calendar_view/calendar_view.dart';

class EventFunctions {

  void addEvents(List<CalendarEventData> events, EventController controller){
    controller.addAll(events);
  }

}