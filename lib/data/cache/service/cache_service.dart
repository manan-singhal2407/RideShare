import '../database/local_database.dart';

class CacheService {
  static Future<LocalDatabase> init() async {
    final localDatabase =
        await $FloorLocalDatabase.databaseBuilder('app_database.db').build();
    return localDatabase;
  }
}
