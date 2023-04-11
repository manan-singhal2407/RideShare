import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_driver_settings_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/driver_dao.dart';
import '../cache/database/entities/driver_entity.dart';
import '../network/model/driver.dart';

@Injectable(as: IDriverSettingsRepository)
class DriverSettingsRepository implements IDriverSettingsRepository {
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getDriverStatusFromLocalDatabase() async {
    DriverEntity? driverEntity;
    await _driverDao.getDriverEntityInfo().then((value) {
      if (value.isNotEmpty) {
        driverEntity = value[0];
      }
    });
    return DataState.success(driverEntity);
  }

  @override
  Future<DataState> getDriverStatusFromDatabase() async {
    Driver? driver;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((value) async {
      driver = Driver.fromJson(value.data()!);
      await _driverDao.insertDriverEntity(convertDriverToDriverEntity(driver!));
    });
    return DataState.success(driver);
  }

  @override
  Future<DataState> saveDriverStatusToDatabase(bool isSharingOn) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .update({'isSharingOn': isSharingOn}).then((documentReference) async {
      onSuccess = true;
      await _driverDao.getDriverEntityInfo().then((value) async {
        if (value.isNotEmpty) {
          DriverEntity driverEntity = value[0];
          driverEntity.isSharingOn = isSharingOn;
          await _driverDao.insertDriverEntity(driverEntity);
        }
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
