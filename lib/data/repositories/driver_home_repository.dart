import 'package:btp/data/network/model/rides.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_driver_home_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/driver_dao.dart';
import '../cache/database/dao/users_dao.dart';
import '../cache/database/entities/driver_entity.dart';
import '../network/model/driver.dart';

@Injectable(as: IDriverHomeRepository)
class DriverHomeRepository implements IDriverHomeRepository {
  final UsersDao _usersDao = getIt<UsersDao>();
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getDriverDataFromLocalDatabase() async {
    DriverEntity? driverEntity;
    await _driverDao.getDriverEntityInfo().then((value) {
      if (value.isNotEmpty) {
        driverEntity = value[0];
      }
    });
    return DataState.success(driverEntity);
  }

  @override
  Future<DataState> getDriverDataFromDatabase() async {
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
  Future<DataState> updateDriverLocation(LatLng latLng) async {
    bool onSuccess = false;
    if (_firebaseAuth.currentUser != null) {
      await _firebaseFirestore
          .collection('Driver')
          .doc(_firebaseAuth.currentUser?.uid)
          .update({
        'currentLatitude': latLng.latitude,
        'currentLongitude': latLng.longitude
      }).then((value) async {
        await _driverDao.getDriverEntityInfo().then((value) async {
          if (value.isNotEmpty) {
            DriverEntity driverEntity = value[0];
            driverEntity.currentLatitude = latLng.latitude;
            driverEntity.currentLongitude = latLng.longitude;
            await _driverDao.insertDriverEntity(driverEntity);
            onSuccess = true;
          }
        });
      });
    }
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> setDriverOnline(bool isDrivingOn) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .update({'isDrivingOn': isDrivingOn}).then((value) async {
      await _driverDao.getDriverEntityInfo().then((value) async {
        if (value.isNotEmpty) {
          DriverEntity driverEntity = value[0];
          driverEntity.isDrivingOn = true;
          await _driverDao.insertDriverEntity(driverEntity);
          onSuccess = true;
        }
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> logoutUserFromDevice() async {
    bool onSuccess = false;
    await _usersDao.clearAllUsersEntity();
    await _driverDao.clearAllDriverEntity();
    await _firebaseAuth.signOut().then((value) {
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> loadDriverRequestedRides() async {
    bool onSuccess = false;
    List<Rides> ridesList = [];
    await _firebaseFirestore
        .collection('Driver')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('Request')
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        String rideId = (value.docs)[i]['request'];
        await _firebaseFirestore
            .collection('Rides')
            .doc(rideId)
            .get()
            .then((value) async {
          ridesList.add(Rides.fromJson(value.data()!));
        });
      }
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(ridesList);
    } else {
      return DataState.error(null, null);
    }
  }
}
