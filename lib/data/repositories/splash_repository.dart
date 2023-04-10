import 'package:injectable/injectable.dart';

import '../../domain/enums/account_type_enum.dart';
import '../../domain/repositories/i_splash_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/users_dao.dart';

@Injectable(as: ISplashRepository)
class SplashRepository implements ISplashRepository {
  final UsersDao _usersDao = getIt<UsersDao>();

  @override
  Future<DataState> checkIfUserIsADriver() async {
    AccountTypeEnum accountTypeEnum = AccountTypeEnum.latest;
    await _usersDao.getUsersEntityInfo().then((value) {
      if (value.isNotEmpty) {
        if (value[0].role == 'driver') {
          accountTypeEnum = AccountTypeEnum.driver;
        } else {
          accountTypeEnum = AccountTypeEnum.user;
        }
      }
    });
    return DataState.success(accountTypeEnum);
  }
}
