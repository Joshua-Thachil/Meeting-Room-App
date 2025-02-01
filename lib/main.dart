import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_app/Views/SchedulePage.dart';
import 'Model/EventModel.dart';
import 'ViewModel/EventFunctions.dart';

void main() async {

  final eventController = EventController();

  // Function call to load all events into the calendar schedule
  EventFunctions.addEvents(EventModel.events, eventController);

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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SchedulePage(),
      ),
    );
  }
}