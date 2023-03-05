import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';

class SplashViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

  final BuildContext _context;

  SplashViewModel(this._context) {
    _checkIfUserLoggedIn();
  }

  void _checkIfUserLoggedIn() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(_context, '/home_screen');
      } else {
        Navigator.pushReplacementNamed(_context, '/login_screen');
      }
    });
  }
}
