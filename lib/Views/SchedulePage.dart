import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_app/Model/EventModel.dart';
import 'package:meeting_room_app/ViewModel/EventFunctions.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final eventController = EventController();
  String currentMonthName = DateFormat('MMM yyyy').format(DateTime.now());
  DateTime now = DateTime.now();
  bool isOccupied = false;

  String formatTimeWithoutLeadingZero(DateTime time) {
    int hour = time.hour;

    // Convert 24-hour to 12-hour format
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    String hourStr = hour.toString();
    String minute = time.minute
        .toString()
        .padLeft(2, '0'); // Ensure minutes have leading zero

    // Remove leading zero from hour if applicable
    if (hourStr.startsWith('0')) {
      hourStr = hourStr.substring(1);
    }

    return '$hourStr:$minute';
  }

  String formatTimeRange(DateTime startTime, DateTime endTime) {
    String start = formatTimeWithoutLeadingZero(startTime);
    String end = formatTimeWithoutLeadingZero(endTime) +
        " ${endTime.hour >= 12 ? "PM" : "AM"}";
    return "$start - $end";
  }

  void showOverlay(
      BuildContext context, String eventTitle, DateTime start, DateTime end) {
    String timeRange = formatTimeRange(start, end);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Center(
        // Use Center widget
        child: Material(
            color: Colors.transparent,
            child: Container(
              width: 1051,
              height: 594,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Color(0xFFF4D35E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 150,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 66, top: 38, right: 36, bottom: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              eventTitle,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 48,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  overlayEntry?.remove();
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 32,
                                ))
                          ],
                        ), // Event Title + Close Icon
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: ShapeDecoration(
                                color: Color(0xFF5E2BFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9)),
                              ),
                              child: Text(
                                'Ongoing', // Backend: "Ongoing" or "Upcoming" or "Completed" Based on event status
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                ),
                              ),
                            ),
                            SizedBox(width: 35),
                            Text(
                              timeRange,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.30000001192092896),
                                fontSize: 20,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ), // Event Status + Event Duration
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ), // Event Description Text
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.person_2_outlined, size: 32),
                        SizedBox(width: 18),
                        Text(
                          'Dr. Vijay Arputharaj',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: eventController,
      child: Scaffold(
        backgroundColor: Color(0xffF3E8EE),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panel Room, 2nd block',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.bold),
                      ), // "Panel Room, 2nd Block" (Room Location)
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.groups_outlined, color: Color(0xff9E979B)),
                          SizedBox(width: 18),
                          Text(
                            '50 - 100',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9E979B),
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          )
                        ],
                      ), // (Room Capacity)
                      SizedBox(height: 2),
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
                      ), // (Room Availability)
                    ],
                  ), // Room Info Frame
                  Text(
                    currentMonthName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ), // Month Name text
                  Icon(Icons
                      .signal_cellular_connected_no_internet_0_bar_sharp) // Backend: Shown when Wifi Connection is lost
                ],
              ),
            ),
            Expanded(
                child: WeekView(
              initialDay: DateTime.now(),
              onPageChange: (date, page) {
                setState(() {
                  currentMonthName = DateFormat('MMM yyyy').format(date);
                });
              },
              backgroundColor: Color(0xffF3E8EE),
              weekTitleHeight: 120,
              heightPerMinute: 1.5,
              startHour: 8,
              endHour: 20,
              weekNumberBuilder: (firstDayOfWeek) {
                return null;
              },

              liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
                  height: 2,
                  color: Color(0xff04243E),
                  showTimeBackgroundView: false,
                  showBullet: true,
                  bulletRadius: 7,
                  timeBackgroundViewWidth: 80,
                  offset: -35),
              hourIndicatorSettings:
                  HourIndicatorSettings(color: Color(0xff9E979B)),
              weekPageHeaderBuilder: WeekHeader.hidden,
              timeLineWidth: 150,
              onEventTap: (events, date) {
                showOverlay(context, events.last.title, events.last.startTime!,
                    events.last.endTime!);
              },
              timeLineBuilder: (date) {
                final hour = date.hour;
                if (hour >= 8 && hour <= 20) {
                  final displayHour = hour % 12 == 0
                      ? 12
                      : hour % 12; // Convert to 12-hour format
                  final amPm = hour < 12 ? 'AM' : 'PM';

                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$displayHour:00 $amPm', // Display hour with AM/PM
                          style: TextStyle(
                            color: Color(0xFF9E979B),
                            fontSize: 16,
                            height: -0.1,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Return an empty container for hours outside the range
                  return Container();
                }
              },
              weekDayBuilder: (date) {
                String day = "";
                switch (date.weekday) {
                  case 1:
                    day = "mon";
                    break;

                  case 2:
                    day = "tue";
                    break;

                  case 3:
                    day = "wed";
                    break;

                  case 4:
                    day = "thu";
                    break;

                  case 5:
                    day = "fri";
                    break;

                  case 6:
                    day = "sat";
                    break;

                  case 7:
                    day = "sun";
                    break;
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                          color: date.day == now.day && date.month == now.month
                              ? Colors.black
                              : Color(0xff9E979B),
                          fontSize: 40,
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      day,
                      style: TextStyle(
                        color: date.day == now.day && date.month == now.month
                            ? Colors.black
                            : Color(0xff9E979B),
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }, // Dates and Days heading styles
              eventTileBuilder:
                  (date, events, boundary, startDuration, endDuration) {
                if (now.isAfter(startDuration) && now.isBefore(endDuration)) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFFF4D35E),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: Color(0xFFDA5959),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // DateFormat('hh:mm').format(events.last.startTime!) + " - " + DateFormat('hh:mm a').format(events.last.endTime!)
                              formatTimeRange(
                                  events.last.startTime!, events.last.endTime!),
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.30000001192092896),
                                fontSize: 14,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ), // Event Time Text
                            Text(
                              events.last.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ), // Event Title Text
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFFF4D35E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatTimeRange(
                                  events.last.startTime!, events.last.endTime!),
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.30000001192092896),
                                fontSize: 14,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ), // Event Time Text
                            Text(
                              events.last.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ), // Event Title Text
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          // Function call to add all events from the EventModel
          EventFunctions().addEvents(EventModel().events, eventController);
        }),
      ),
    );
  }
}
