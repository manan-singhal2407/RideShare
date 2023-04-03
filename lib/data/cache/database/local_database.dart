import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/driver_dao.dart';
import 'dao/users_dao.dart';
import 'entities/driver_entity.dart';
import 'entities/users_entity.dart';

part 'local_database.g.dart';

@Database(version: 1, entities: [
  UsersEntity,
  DriverEntity,
])
abstract class LocalDatabase extends FloorDatabase {
  UsersDao get usersDao;
  DriverDao get driverDao;
}
