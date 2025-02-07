
import 'package:floor/floor.dart';
import 'EventEntity.dart';

@dao
abstract class EventDAO{
  
  @Query("SELECT * from Events")
  Future<List<Events>> getAllEvents();

  @Query("SELECT title from Events")
  Future<List<String>> getAllTitles();

  @insert
  Future<void> insertEvent(Events event);

  @Query("DELETE from Events")
  Future<void> deleteAllEvents();
}