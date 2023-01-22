import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';

class LoginVerifyViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  final BuildContext _context;

  LoginVerifyViewModel(this._context) {
  }

  void onClickVerifyButton() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(_context, '/home_screen');
      } else {
        Navigator.pushReplacementNamed(_context, '/login_screen');
      }
    });
  }
}
