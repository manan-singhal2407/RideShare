import 'package:floor/floor.dart';

import '../entities/driver_entity.dart';

@dao
abstract class DriverDao {
  @Query('SELECT * FROM DriverEntity')
  Future<List<DriverEntity>> getDriverEntityInfo();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDriverEntity(DriverEntity driverEntity);

  @Query('DELETE FROM DriverEntity')
  Future<void> clearAllDriverEntity();
}
