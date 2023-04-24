import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_rider_home_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/driver_dao.dart';
import '../cache/database/dao/users_dao.dart';
import '../cache/database/entities/users_entity.dart';
import '../network/model/driver.dart';
import '../network/model/users.dart';

@Injectable(as: IRiderHomeRepository)
class RiderHomeRepository implements IRiderHomeRepository {
  final UsersDao _usersDao = getIt<UsersDao>();
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getUserDataFromLocalDatabase() async {
    UsersEntity? usersEntity;
    await _usersDao.getUsersEntityInfo().then((value) {
      if (value.isNotEmpty) {
        usersEntity = value[0];
      }
    });
    return DataState.success(usersEntity);
  }

  @override
  Future<DataState> getUserDataFromDatabase() async {
    Users? users;
    await _firebaseFirestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((value) async {
      users = Users.fromJson(value.data()!);
      await _usersDao.insertUsersEntity(convertUsersToUsersEntity(users!));
    });
    return DataState.success(users);
  }

  @override
  Future<DataState> createUserToDriver(LatLng latLng) async {
    bool onSuccess = false;
    await _usersDao.getUsersEntityInfo().then((value) async {
      if (value.isNotEmpty) {
        UsersEntity usersEntity = value[0];
        usersEntity.role = 'driver';
        await _usersDao.insertUsersEntity(usersEntity);
        await _firebaseFirestore
            .collection('Users')
            .doc(usersEntity.userUid)
            .update({'role': 'driver'});

        var random = Random();
        var fourDigitNumber = random.nextInt(9000) + 1000;

        Driver driver = Driver(
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
          '',
          '',
          '',
          usersEntity.phoneNumber,
          usersEntity.fullPhoneNumber,
          usersEntity.emailId,
          usersEntity.userName,
          usersEntity.userUid,
          usersEntity.status,
          'type1',
          'CH01 AH $fourDigitNumber',
          0,
          0,
          0,
          0,
          true,
          true,
          false,
          false,
          latLng.latitude,
          latLng.longitude,
          '',
        );
        await _firebaseFirestore
            .collection('Driver')
            .doc(usersEntity.userUid)
            .set(driver.toJson())
            .then((value) async {
          await _driverDao
              .insertDriverEntity(convertDriverToDriverEntity(driver))
              .then((value) {
            onSuccess = true;
          });
        });
      }
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
    await _firebaseAuth.signOut().then((value) {
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
