import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../domain/extension/model_extension.dart';
import '../../domain/repositories/i_phone_otp_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../cache/database/dao/driver_dao.dart';
import '../cache/database/dao/users_dao.dart';
import '../network/model/driver.dart';
import '../network/model/users.dart';

@Injectable(as: IPhoneOtpRepository)
class PhoneOtpRepository implements IPhoneOtpRepository {
  final UsersDao _usersDao = getIt<UsersDao>();
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<void> checkForAutoOtpVerification(
    String phone,
    ValueSetter<UserCredential> onVerificationCompleted,
    ValueSetter<FirebaseAuthException> onVerificationFailed,
    ValueSetter<String> onCodeSent,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential authCredential) async {
        await _firebaseAuth
            .signInWithCredential(authCredential)
            .then(onVerificationCompleted);
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? forceResendingToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String timeout) {},
    );
  }

  @override
  Future<void> checkForOtpVerification(
    String verificationId,
    String otp,
    ValueSetter<UserCredential> onVerificationCompleted,
  ) async {
    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await _firebaseAuth
        .signInWithCredential(authCredential)
        .then(onVerificationCompleted);
  }

  @override
  Future<DataState> settingUpLoginAccount(bool updateDriverDao) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser?.uid)
        .get()
        .then((value) async {
      Users users = Users.fromJson(value.data()!);
      await _usersDao.insertUsersEntity(convertUsersToUsersEntity(users));
      if (updateDriverDao) {
        await _firebaseFirestore
            .collection('Driver')
            .doc(_firebaseAuth.currentUser?.uid)
            .get()
            .then((value) async {
          Driver driver = Driver.fromJson(value.data()!);
          await _driverDao.insertDriverEntity(convertDriverToDriverEntity(driver));
          onSuccess = true;
        });
      } else {
        onSuccess = true;
      }
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }

  @override
  Future<DataState> settingUpNewAccount(Users users) async {
    bool onSuccess = false;
    users.userUid = _firebaseAuth.currentUser?.uid ?? '';
    await _firebaseFirestore
        .collection('Users')
        .doc(_firebaseAuth.currentUser?.uid)
        .set(users.toJson())
        .then((value) {
      _usersDao.insertUsersEntity(convertUsersToUsersEntity(users));
      onSuccess = true;
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
