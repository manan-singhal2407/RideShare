import 'dart:async';

import 'package:btp/presentation/theme/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/cache/database/entities/driver_entity.dart';
import '../../../../data/network/model/driver.dart';
import '../../../../domain/repositories/i_driver_home_repository.dart';
import '../../../base/injectable.dart';

class DriverHomeViewModel extends ChangeNotifier {
  final IDriverHomeRepository _driverHomeRepository =
      getIt<IDriverHomeRepository>();

  final BuildContext _context;

  late LatLng _driverLocation = const LatLng(30.7333, 76.7794);
  Location location = Location();
  loc.LocationData? _currentPosition;

  String _driverProfileUrl = '';
  String _driverName = '';
  String _driverPhoneNumber = '';

  DriverHomeViewModel(this._context) {
    _getDataFromLocalDatabase();
    _getDataFromDatabase();
    _getCurrentLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation();
    });
  }

  String get driverProfileUrl => _driverProfileUrl;

  String get driverName => _driverName;

  String get driverPhoneNumber => _driverPhoneNumber;

  void _getDataFromLocalDatabase() async {
    await _driverHomeRepository.getDriverDataFromLocalDatabase().then((value) {
      if (value.data != null) {
        DriverEntity driverEntity = value.data as DriverEntity;
        _driverProfileUrl = driverEntity.profileUrl;
        _driverName = driverEntity.driverName;
        _driverPhoneNumber = driverEntity.phoneNumber;
        notifyListeners();
      }
    });
  }

  void _getDataFromDatabase() async {
    await _driverHomeRepository.getDriverDataFromDatabase().then((value) {
      if (value.data != null) {
        Driver driver = value.data as Driver;
        _driverProfileUrl = driver.profileUrl;
        _driverName = driver.driverName;
        _driverPhoneNumber = driver.phoneNumber;
        notifyListeners();

        if (driver.currentRideId.isNotEmpty) {
          // todo
        }
      }
    });
  }

  void _getCurrentLocation() async {
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _currentPosition = await location.getLocation();
    _driverLocation = LatLng(
      _currentPosition!.latitude!,
      _currentPosition!.longitude!,
    );
    notifyListeners();
    await _driverHomeRepository.updateDriverLocation(_driverLocation);
  }

  void logoutDriver() async {
    showLoadingDialogBox(_context);
    _driverHomeRepository.logoutUserFromDevice().then((value) {
      Navigator.pushNamedAndRemoveUntil(
        _context,
        '/login_screen',
        (r) => false,
      );
    });
  }
}
