import 'package:floor/floor.dart';

@entity
class EventEntity{

  @PrimaryKey(autoGenerate: true)
  int? id;

  String? title;
  String? startTime;
  String? endTime;

  EventEntity(this.id, this.title, this.startTime, this.endTime);
}