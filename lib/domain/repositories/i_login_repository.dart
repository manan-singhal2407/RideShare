import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../domain/state/data_state.dart';

abstract class ILoginRepository {
  Future<DataState> checkIfPhoneNumberAccountExists(String phone);
}
