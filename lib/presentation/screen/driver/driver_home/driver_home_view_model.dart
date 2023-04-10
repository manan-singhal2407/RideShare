import 'dart:async';

import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

class DriverHomeViewModel extends ChangeNotifier {
  final BuildContext _context;

  late LatLng _pickUpLocation = const LatLng(30.7333, 76.7794);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _pickUpLocationAddress;
  Marker? _sourcePosition;

  DriverHomeViewModel(this._context) {
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

  void logoutDriver() async {
    // todo clear all tables data
  }
}
