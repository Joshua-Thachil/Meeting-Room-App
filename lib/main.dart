import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_app/Repository/database.dart';
import 'package:meeting_room_app/Views/DailySchedulePage.dart';
import 'package:meeting_room_app/Views/WeeklySchedulePage.dart';
import 'Repository/EventEntity.dart';
import 'ViewModel/EventFunctions.dart';
import 'package:flutter/services.dart';

import 'Views/SideBarMenu.dart';

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

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
        routes: {
          '/': (context) => HomePage(), // Your home screen
          '/dailySchedule': (context) => DailySchedulePage(),
          '/weeklySchedule': (context) => SchedulePage(),
        },
        initialRoute: '/',
        title: 'Venue booking schedule display',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentRoute = '/weeklySchedule';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _currentRoute = ModalRoute.of(context)!.settings.name!;
    });
  }

  void onDrawerItemSelected(String route) {
    setState(() {
      _currentRoute = route; // Update the current route
      _buildBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3E8EE),
      appBar: AppBar(
        iconTheme: IconThemeData(size: 50, color: Colors.white),
        backgroundColor: Color(0xff04243E),
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'CHRIST (Deemed to be University)\n',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                TextSpan(
                  text: 'Meeting Room Info Display',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.20,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room 911, Audi Block',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.bold),
                ), // "Panel Room, 2nd Block" (Room Location)
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 18),
                    Text(
                      '50',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    )
                  ],
                ), // (Room Capacity)
                SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Current Status :  ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(
                            0xFF9E0031), // Backend: Color Changes Based on if an event is going on in the room or not (Room available Color: Color(0xff729B79))
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Occupied',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ), // (Room Availability)
              ],
            ),
          ),
        ],
      ),
      drawer: SideBarMenu(currentRoute: _currentRoute, onItemSelected: onDrawerItemSelected,),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Return the correct widget based on the current route
    final currentRoute = _currentRoute;
    print('Current Route: $currentRoute');

    if (currentRoute == '/dailySchedule') {
      return DailySchedulePage();
    } else if (currentRoute == '/weeklySchedule') {
      return SchedulePage();
    } else {
      return SchedulePage(); // Default to your home screen
    }
  }
}