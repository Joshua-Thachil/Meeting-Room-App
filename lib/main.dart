import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_app/Repository/database.dart';
import 'package:meeting_room_app/Views/WeeklySchedulePage.dart';
import 'Repository/EventEntity.dart';
import 'ViewModel/EventFunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorAppDatabase.databaseBuilder("venueDB.db").build();
  final dao = database.eventDAO;

  // Events event1 = Events(null, "Test Event 2", "02:00:00", "04:00:00");
  // dao.insertEvent(event1);

  // List<Events> getEvents = await dao.getAllEvents();
  // print(getEvents[0].title);

  final eventController = EventController();

  // Function call to load all events into the calendar schedule
  EventFunctions.addEvents(eventController);

  runApp(MyApp(calendarController: eventController));
}

class MyApp extends StatelessWidget {

  EventController calendarController;

  MyApp({super.key, required this.calendarController});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: calendarController,
      child: MaterialApp(
        title: 'Venue booking schedule display',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SchedulePage(),
      ),
    );
  }
}