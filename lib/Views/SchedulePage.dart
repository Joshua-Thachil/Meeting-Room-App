import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
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
                              0xFF9E0031), // Backend: Color Changes Based on Availability (Available Color: Color(0xff729B79))
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
                  Icon(Icons
                      .signal_cellular_connected_no_internet_0_bar_sharp) // Backend: Shown when Wifi Connection is lost
                ],
              ),
            ),
            Expanded(
                child: WeekView(
              initialDay: DateTime.now(),
              backgroundColor: Color(0xffF3E8EE),
              controller: EventController(),
              weekTitleHeight: 120,
              heightPerMinute: 1.5,
              startHour: 8,
              endHour: 20,
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
                          color: date.day == DateTime.now().day
                              ? Colors.black
                              : Color(0xff9E979B),
                          fontSize: 40,
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      day,
                      style: TextStyle(
                        color: date.day == DateTime.now().day
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
            )),
          ],
        ),
      ),
    );
  }
}
