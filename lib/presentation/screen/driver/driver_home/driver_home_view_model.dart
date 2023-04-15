import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/cache/database/entities/driver_entity.dart';
import '../../../../data/network/model/driver.dart';
import '../../../../domain/repositories/i_driver_home_repository.dart';
import '../../../base/injectable.dart';
import '../../../theme/widgets/loading.dart';

// todo onDestroy set isDrivingOn to false if currentRideId is empty

class DriverHomeViewModel extends ChangeNotifier {
  final IDriverHomeRepository _driverHomeRepository =
      getIt<IDriverHomeRepository>();

  final BuildContext _context;

  late LatLng _driverLocation = const LatLng(30.7333, 76.7794);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  Marker? _sourcePosition;

  String _driverProfileUrl = '';
  String _driverName = '';
  String _driverPhoneNumber = '';
  bool _driverOffline = true;

  DriverHomeViewModel(this._context) {
    _getDataFromLocalDatabase();
    _getDataFromDatabase();
    _getCurrentLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation();
    });
  }

  LatLng get driverLocation => _driverLocation;

  Completer<GoogleMapController?> get controller => _controller;

  Marker? get sourcePosition => _sourcePosition;

  String get driverProfileUrl => _driverProfileUrl;

  String get driverName => _driverName;

  String get driverPhoneNumber => _driverPhoneNumber;

  bool get driverOffline => _driverOffline;

  void _getDataFromLocalDatabase() async {
    await _driverHomeRepository
        .getDriverDataFromLocalDatabase()
        .then((value) async {
      if (value.data != null) {
        DriverEntity driverEntity = value.data as DriverEntity;
        _driverProfileUrl = driverEntity.profileUrl;
        _driverName = driverEntity.driverName;
        _driverPhoneNumber = driverEntity.fullPhoneNumber;
        _driverOffline = !driverEntity.isDrivingOn;
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
        _driverPhoneNumber = driver.fullPhoneNumber;
        _driverOffline = !driver.isDrivingOn;
        notifyListeners();

        if (driver.currentRideId.isNotEmpty) {
          // todo send user to next screen with ride id
        }
      }
    });
  }

  void _getCurrentLocation() async {
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _currentPosition = await location.getLocation();
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
      zoom: 16,
    )));
    _driverLocation = LatLng(
      _currentPosition!.latitude!,
      _currentPosition!.longitude!,
    );
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _driverLocation,
    );
    notifyListeners();
    await _driverHomeRepository.updateDriverLocation(_driverLocation);
  }

  void onClickGoButton() async {
    _driverOffline = false;
    _driverHomeRepository.setDriverOnline(true).then((value) {
      if (value.data != null) {
        notifyListeners();
        onClickNextButton();
      }
    });
  }

  void onClickNextButton() async {
    Navigator.pushNamed(
      _context,
      '/driver_ride_request_screen',
    );
  }

  void onClickSetOfflineButton() async {
    _driverOffline = true;
    _driverHomeRepository.setDriverOnline(false).then((value) {
      if (value.data != null) {
        notifyListeners();
      }
    });
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
