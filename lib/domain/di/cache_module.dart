import 'package:injectable/injectable.dart';

import '../../data/cache/database/dao/driver_dao.dart';
import '../../data/cache/database/dao/users_dao.dart';
import '../../data/cache/database/local_database.dart';
import '../../data/cache/service/cache_service.dart';

@module
abstract class CacheModule {
  @preResolve
  Future<LocalDatabase> get localDatabase => CacheService.init();

  @injectable
  UsersDao usersDao(LocalDatabase localDatabase) => localDatabase.usersDao;

  @injectable
  DriverDao adsRulesDao(LocalDatabase localDatabase) => localDatabase.driverDao;
}
