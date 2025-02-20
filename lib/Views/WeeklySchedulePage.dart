import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import '../Repository/EventEntity.dart';
import 'SideBarMenu.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  String currentMonthName = DateFormat('MMMM\nyyyy').format(DateTime.now());
  DateTime now = DateTime.now();
  DateTime currentWeek = DateTime.now();
  UniqueKey weekViewKey = UniqueKey();
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

  void showOverlay(BuildContext context, String eventTitle,
      String? eventDescription, DateTime start, DateTime end, String booker) {
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
                color: Color(0xffd5c6e0),
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
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: 850,
                                  maxHeight:
                                      60), // Constrain the width of the Marquee
                              child: eventTitle.length > 30
                                  ? Marquee(
                                      text: eventTitle,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 48,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 20.0,
                                      velocity: 100.0,
                                      pauseAfterRound: Duration(seconds: 1),
                                      startPadding: 10.0,
                                      accelerationDuration:
                                          Duration(seconds: 1),
                                      accelerationCurve: Curves.linear,
                                      decelerationDuration:
                                          Duration(milliseconds: 500),
                                      decelerationCurve: Curves.easeOut,
                                    )
                                  : Text(
                                      eventTitle,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 48,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w700,
                                      ),
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
                            eventDescription!,
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
                          booker,
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

  void goToNextWeek() {
    setState(() {
      currentWeek = currentWeek.add(Duration(days: 7));
      currentMonthName = DateFormat('MMMM\nyyyy').format(currentWeek);
      weekViewKey = UniqueKey();
    });
  }

  void goToPrevWeek() {
    setState(() {
      currentWeek = currentWeek.add(Duration(days: -7));
      currentMonthName = DateFormat('MMMM\nyyyy').format(currentWeek);
      weekViewKey = UniqueKey();
    });
  }

  // Function to show the month picker dialog
  void _showMonthPicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: currentWeek,
      lastDate: DateTime(2050),
    );

    if (selectedDate != null) {
      setState(() {
        currentWeek = DateTime(selectedDate.year, selectedDate.month,
            1); // Set to the beginning of the selected month
        currentMonthName = DateFormat('MMMM\nyyyy')
            .format(currentWeek); // Update the month name
        weekViewKey = UniqueKey();
      });
    }

    currentWeek = selectedDate as DateTime;
    weekViewKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3E8EE),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Expanded(
                child: Stack(children: [
              WeekView(
                initialDay: currentWeek,
                key: weekViewKey,
                onPageChange: (date, page) {
                  setState(() {
                    if (date.isAfter(currentWeek)) {
                      currentWeek = currentWeek.add(Duration(days: 7));
                      currentMonthName =
                          DateFormat('MMMM\nyyyy').format(currentWeek);
                    } else {
                      currentWeek = currentWeek.add(Duration(days: -7));
                      currentMonthName =
                          DateFormat('MMMM\nyyyy').format(currentWeek);
                    }
                  });
                },
                backgroundColor: Color(0xffF3E8EE),
                weekTitleHeight: 120,
                heightPerMinute: 1.2,
                startHour: 9,
                endHour: 18,
                weekDays: [
                  WeekDays.monday,
                  WeekDays.tuesday,
                  WeekDays.wednesday,
                  WeekDays.thursday,
                  WeekDays.friday,
                  WeekDays.saturday
                ],
                weekNumberBuilder: (firstDayOfWeek) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          currentMonthName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () {
                          _showMonthPicker(context);
                        },
                      ),
                    ),
                  );
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
                  final CustomCalendarEventData event =
                      events.last as CustomCalendarEventData;
                  showOverlay(context, event.title, event.description,
                      event.startTime!, event.endTime!, event.bookedBy);
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
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                            color:
                                date.day == now.day && date.month == now.month
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color(0xffd5c6e0),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: Color(0xFF000000),
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
                                formatTimeRange(events.last.startTime!,
                                    events.last.endTime!),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color(0xffd5c6e0),
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
                                formatTimeRange(events.last.startTime!,
                                    events.last.endTime!),
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 152, right: 18, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 32,
                        ),
                        onTap: () {
                          goToPrevWeek();
                        },
                      ), // Previous Week Button
                      GestureDetector(
                        child: Icon(
                          Icons.navigate_next,
                          size: 32,
                        ),
                        onTap: () {
                          goToNextWeek();
                        },
                      ), // Next Week Button
                    ],
                  ),
                ),
              ) // Arrows for navigating the weekView
            ])),
          ],
        ),
      ),
    );
  }
}