import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../base/injectable.dart';

class SplashViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();

  final BuildContext _context;

  SplashViewModel(this._context) {
    _askForPermission();
  }

  void _askForPermission() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    permissionGranted = await location.hasPermission();
    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      _checkIfUserLoggedIn();
    } else if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _askForPermission();
      } else {
        _checkIfUserLoggedIn();
      }
    } else if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _askForPermission();
      } else {
        _checkIfUserLoggedIn();
      }
    }
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
