import 'package:calendar_view/calendar_view.dart';
import 'package:meeting_room_app/Repository/EventDAO.dart';
import 'package:meeting_room_app/Repository/EventEntity.dart';

import 'API_Service.dart';

class EventFunctions {

  static void addEvents(EventController controller) async {

    // Get All Events for this month
    List<CalendarEventData> monthEvents = await EventApiService.fetchEvents(
        DateTime.now().add(Duration(days: -14)).toIso8601String(), DateTime.now().add(Duration(days: 30)).toIso8601String());

    controller.addAll(monthEvents);
  }

}