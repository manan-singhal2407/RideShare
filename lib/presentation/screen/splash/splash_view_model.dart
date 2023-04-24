import 'package:location/location.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/account_type_enum.dart';
import '../../../domain/repositories/i_splash_repository.dart';
import '../../base/injectable.dart';

class SplashViewModel extends ChangeNotifier {
  final ISplashRepository _splashRepository = getIt<ISplashRepository>();

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
    _splashRepository.checkIfUserIsADriver().then((value) {
      AccountTypeEnum accountTypeEnum = value.data as AccountTypeEnum;
      if (accountTypeEnum == AccountTypeEnum.user) {
        Navigator.pushReplacementNamed(_context, '/rider_home_screen');
      } else if (accountTypeEnum == AccountTypeEnum.driver) {
        Navigator.pushReplacementNamed(_context, '/driver_home_screen');
      } else if (accountTypeEnum == AccountTypeEnum.latest) {
        Navigator.pushReplacementNamed(_context, '/login_screen');
      }
    });
  }
}
