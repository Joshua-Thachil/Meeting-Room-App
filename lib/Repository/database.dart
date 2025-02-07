import 'dart:async';

import 'package:floor/floor.dart';
import 'EventDAO.dart';
import 'EventEntity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Events])
abstract class AppDatabase extends FloorDatabase {

  EventDAO get eventDAO;

}