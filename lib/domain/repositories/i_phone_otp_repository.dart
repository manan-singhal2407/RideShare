import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/network/model/users.dart';
import '../../domain/state/data_state.dart';

abstract class IPhoneOtpRepository {
  Future<void> checkForAutoOtpVerification(
    String phone,
    ValueSetter<UserCredential> onVerificationCompleted,
    ValueSetter<FirebaseAuthException> onVerificationFailed,
    ValueSetter<String> onCodeSent,
  );

  Future<DataState> checkForOtpVerification(
    String verificationId,
    String otp,
  );

  Future<DataState> settingUpLoginAccount(bool updateDriverDao);

  Future<DataState> settingUpNewAccount(Users users);
}
