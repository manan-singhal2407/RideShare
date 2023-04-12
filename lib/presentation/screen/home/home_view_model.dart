import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../data/cache/database/dao/driver_dao.dart';
import '../../../data/cache/database/dao/users_dao.dart';
import '../../../data/cache/database/entities/users_entity.dart';
import '../../../data/network/model/driver.dart';
import '../../../domain/extension/model_extension.dart';
import '../../base/injectable.dart';
import '../../extension/utils_extension.dart';

class HomeViewModel extends ChangeNotifier {
  final UsersDao _usersDao = getIt<UsersDao>();
  final DriverDao _driverDao = getIt<DriverDao>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  final BuildContext _context;

  late LatLng _pickUpLocation = const LatLng(30.7333, 76.7794);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _pickUpLocationAddress;
  Marker? _sourcePosition;

  HomeViewModel(this._context) {
    _getCurrentLocation();
  }

  LatLng get pickUpLocation => _pickUpLocation;

  Completer<GoogleMapController?> get controller => _controller;

  String? get pickUpLocationAddress => _pickUpLocationAddress;

  Marker? get sourcePosition => _sourcePosition;

  void _getCurrentLocation() async {
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _currentPosition = await location.getLocation();
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!),
      zoom: 16,
    )));
    _pickUpLocation = LatLng(
      _currentPosition!.latitude!,
      _currentPosition!.longitude!,
    );
    notifyListeners();
    getAddressFromPickUpMovement();
  }

  void getAddressFromPickUpMovement() async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
      latitude: _pickUpLocation.latitude,
      longitude: _pickUpLocation.longitude,
      googleMapApiKey: googleMapsApiKey,
    );
    _pickUpLocationAddress = data.address;
    notifyListeners();
  }

  void onCameraPositionChange(LatLng location) async {
    _pickUpLocation = location;
    notifyListeners();
  }

  void addSourcePositionMarker(LatLng latLng, Marker marker) async {
    final GoogleMapController? controller = await _controller.future;
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 16,
    )));
    _pickUpLocation = latLng;
    _sourcePosition = marker;
    notifyListeners();
    getAddressFromPickUpMovement();
  }

  void openCaptainVerificationPage() async {
    await _usersDao.getUsersEntityInfo().then((value) async {
      if (value.isNotEmpty) {
        UsersEntity usersEntity = value[0];
        Driver driver = Driver(
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch + 3600000,
          '',
          '',
          '',
          usersEntity.phoneNumber,
          usersEntity.fullPhoneNumber,
          usersEntity.emailId,
          usersEntity.userName,
          usersEntity.userUid,
          'active',
          'type1',
          'RJ14 PE 7894',
          4.5,
          0,
          0,
          0,
          true,
          true,
          false,
          false,
          _currentPosition != null ? _currentPosition!.latitude! : 0,
          _currentPosition != null ? _currentPosition!.longitude! : 0,
          '',
        );
        usersEntity.role = 'driver';
        await _usersDao.insertUsersEntity(usersEntity);
        await _firebaseFirestore
            .collection('Users')
            .doc(usersEntity.userUid)
            .update({'role': 'driver'});
        await _firebaseFirestore
            .collection('Driver')
            .doc(usersEntity.userUid)
            .set(driver.toJson())
            .then((value) async {
          await _driverDao
              .insertDriverEntity(convertDriverToDriverEntity(driver))
              .then((value) {
            Navigator.pushNamedAndRemoveUntil(
              _context,
              '/driver_home_screen',
              (r) => false,
            );
          });
        });
      }
    });
  }
}
