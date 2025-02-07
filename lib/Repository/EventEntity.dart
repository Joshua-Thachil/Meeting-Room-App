import 'package:floor/floor.dart';

@entity
class Events{ // Events Table to store event data in sqlite db

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? title;
  String? startTime;
  String? endTime;

  Events(this.id, this.title, this.startTime, this.endTime);
}