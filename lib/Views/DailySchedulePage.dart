import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';

import '../Repository/EventEntity.dart';

class DailySchedulePage extends StatefulWidget {
  const DailySchedulePage({super.key});

  @override
  State<DailySchedulePage> createState() => _DailySchedulePageState();
}

class _DailySchedulePageState extends State<DailySchedulePage> {
  DateTime now = DateTime.now();
  DateTime _currentDate = DateTime.now();
  String currentMonthName = DateFormat('MMMM\nyyyy').format(DateTime.now());
  UniqueKey dayViewKey = UniqueKey();

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

  String _getDayOfMonth(DateTime date) {
    final day = date.day;
    // Add the appropriate suffix (st, nd, rd, th)
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String _getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date); // Full day name (e.g., "Monday")
  }

  void goToNextDay() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: 1));
      currentMonthName = DateFormat('MMMM\nyyyy').format(_currentDate);
      dayViewKey = UniqueKey();
    });
  }

  void goToPrevDay() {
    setState(() {
      _currentDate = _currentDate.add(Duration(days: -1));
      currentMonthName = DateFormat('MMMM\nyyyy').format(_currentDate);
      dayViewKey = UniqueKey();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3E8EE),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xff9E979B))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 121.5,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Color(0xff9E979B))),
                        ),
                        child: Center(
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
                        ),
                      ), // Month and Year Container
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _getDayOfMonth(_currentDate),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w700,
                                        height: 0.48,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w500,
                                        height: 0.48,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _getDayOfWeek(_currentDate),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0.48,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ), // Date and Day Widget
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 250.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.keyboard_arrow_left,
                                        size: 32,
                                      ),
                                      onTap: () {
                                        goToPrevDay();
                                      },
                                    ), // Previous Week Button
                                    GestureDetector(
                                      child: Icon(
                                        Icons.navigate_next,
                                        size: 32,
                                      ),
                                      onTap: () {
                                        goToNextDay();
                                      },
                                    ), // Next Week Button
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) // Date and Day Section
                    ],
                  ),
                ), // Date Header
                Expanded(
                  child: DayView(
                    key: dayViewKey,
                    backgroundColor: const Color(0xffF3E8EE),
                    startHour: 9,
                    endHour: 18,
                    initialDay: _currentDate,
                    heightPerMinute: 1.2,
                    emulateVerticalOffsetBy: 10,
                    onPageChange: (date, page) {
                      setState(() {
                        _currentDate = date; // Update the current date
                        currentMonthName = DateFormat('MMMM\nyyyy').format(_currentDate);
                      });
                    },
                    onEventTap: (events, date) {
                      final CustomCalendarEventData event =
                          events.last as CustomCalendarEventData;
                      showOverlay(context, event.title, event.description,
                          event.startTime!, event.endTime!, event.bookedBy);
                    },
                    dayTitleBuilder: (date) {
                      return const SizedBox.shrink();
                    },
                    eventTileBuilder:
                        (date, events, boundary, startDuration, endDuration) {
                      if (now.isAfter(startDuration) &&
                          now.isBefore(endDuration)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 35),
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
                                      fontSize: 16,
                                      fontFamily: 'Instrument Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ), // Event Time Text
                                  Text(
                                    events.last.title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
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
                              vertical: 2, horizontal: 35),
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
                                      fontSize: 16,
                                      fontFamily: 'Instrument Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ), // Event Time Text
                                  Text(
                                    events.last.title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
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
                    liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
                      height: 2,
                      color: const Color(0xff04243E),
                      showTimeBackgroundView: false,
                      showBullet: true,
                      bulletRadius: 7,
                      timeBackgroundViewWidth: 80,
                      offset: -35,
                    ),
                    hourIndicatorSettings:
                        const HourIndicatorSettings(color: Color(0xff9E979B)),
                    timeLineBuilder: (date) {
                      final hour = date.hour;
                      if (hour >= 8 && hour <= 20) {
                        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
                        final amPm = hour < 12 ? 'AM' : 'PM';

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$displayHour:00 $amPm',
                                style: const TextStyle(
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
                        return Container();
                      }
                    },
                  ),
                ), // Day View Widget
              ],
            ),
          ), // Calendar and Dates Header Section
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Color(0xffD9CCD3)))),
              child: Column(
                children: [
                  Container(
                    height: 230,
                    width: double.infinity,
                    color: Colors.black,
                  ), // Video Placeholder
                  Container(
                    width: double.infinity,
                    height: 71,
                    decoration: BoxDecoration(color: Color(0xFF04243E)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ) // Upcoming Events Heading
                ],
              ),
            ),
          ), // Video and Upcoming Events Section
        ],
      ),
    );
  }
}
