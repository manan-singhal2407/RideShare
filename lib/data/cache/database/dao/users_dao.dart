import 'package:floor/floor.dart';

import '../entities/users_entity.dart';

@dao
abstract class UsersDao {
  @Query('SELECT * FROM UsersEntity')
  Future<List<UsersEntity>> getUsersEntityInfo();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUsersEntity(UsersEntity usersEntity);
}
