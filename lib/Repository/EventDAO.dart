
import 'package:floor/floor.dart';
import 'EventEntity.dart';

@dao
abstract class EventDAO{
  
  @Query("SELECT * from EventEntity")
  Future<List<EventEntity>> getAllEvents();

  @Query("SELECT title from EventEntity")
  Future<List<String>> getAllTitles();

  @insert
  Future<void> insertEvent(EventEntity event);
}