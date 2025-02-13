import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:calendar_view/calendar_view.dart';
import 'package:meeting_room_app/Repository/EventEntity.dart';

class EventApiService {
  static Future<List<CalendarEventData>> fetchEvents(
      String startDate, String endDate) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.5.13.206:8095/MeetingInfoDisplaySystem/getVenueEvents'),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode({
          "campusDTO": {
            "value": "2",
            "label": "BANGALORE CENTRAL CAMPUS",
            "isUserCampus": true
          },
          "eventDTO": {"value": "78"}, // value 88 is for Conference hall
          "blockDTO": null,
          "startDate": startDate,
          "endDate": endDate,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> eventsData = jsonDecode(response.body);
        return eventsData.map((eventJson) {
          return CustomCalendarEventData(
              title: eventJson['description'] ?? '',
              description: '',
              date: DateTime.parse(
                  eventJson['start']), // Assuming 'start' is in ISO 8601 format
              startTime: DateTime.parse(eventJson['start']),
              endTime: DateTime.parse(eventJson['end']),
              bookedBy: eventJson['venueBookedDetailsDTO']?['bookedBy'] ?? '');
        }).toList();
      } else {
        // Handle API errors (e.g., throw an exception)
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error fetching events: $e');
      return [];
    }
  }
}
