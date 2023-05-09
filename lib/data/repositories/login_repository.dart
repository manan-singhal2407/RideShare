import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/enums/account_type_enum.dart';
import '../../domain/enums/phone_auth_enum.dart';
import '../../domain/repositories/i_login_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';

@Injectable(as: ILoginRepository)
class LoginRepository implements ILoginRepository {
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> checkIfPhoneNumberAccountExists(String phone) async {
    bool onSuccess = false;
    PhoneAuthEnum phoneAuthEnum = PhoneAuthEnum.register;
    AccountTypeEnum accountTypeEnum = AccountTypeEnum.user;
    await _firebaseFirestore
        .collection('Users')
        .where('fullPhoneNumber', isEqualTo: phone)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        phoneAuthEnum = PhoneAuthEnum.login;
        accountTypeEnum = value.docs[0].data()['role'] == 'driver'
            ? AccountTypeEnum.driver
            : AccountTypeEnum.user;
      }
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success([phoneAuthEnum, accountTypeEnum]);
    } else {
      return DataState.error(null, null);
    }
  }
}
