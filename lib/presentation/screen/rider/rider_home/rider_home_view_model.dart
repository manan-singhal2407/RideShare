import 'dart:async';

import 'package:btp/domain/extension/model_extension.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/cache/database/entities/users_entity.dart';
import '../../../../data/network/model/users.dart';
import '../../../../domain/repositories/i_rider_home_repository.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/widgets/loading.dart';

class RiderHomeViewModel extends ChangeNotifier {
  final IRiderHomeRepository _riderHomeRepository =
      getIt<IRiderHomeRepository>();

  final BuildContext _context;

  late LatLng _pickUpLocation = const LatLng(30.7333, 76.7794);
  loc.Location location = loc.Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  String? _pickUpLocationAddress;
  Marker? _sourcePosition;

  String _riderProfileUrl = '';
  String _riderName = '';
  String _riderPhoneNumber = '';
  Users? _users;

  RiderHomeViewModel(this._context) {
    _getDataFromLocalDatabase();
    _getDataFromDatabase();
    _getCurrentLocation();
  }

  LatLng get pickUpLocation => _pickUpLocation;

  Completer<GoogleMapController?> get controller => _controller;

  String? get pickUpLocationAddress => _pickUpLocationAddress;

  Marker? get sourcePosition => _sourcePosition;

  String get riderProfileUrl => _riderProfileUrl;

  String get riderName => _riderName;

  String get riderPhoneNumber => _riderPhoneNumber;

  Users? get users => _users;

  void _getDataFromLocalDatabase() async {
    await _riderHomeRepository
        .getUserDataFromLocalDatabase()
        .then((value) async {
      if (value.data != null) {
        UsersEntity usersEntity = value.data as UsersEntity;
        _riderProfileUrl = usersEntity.profileUrl;
        _riderName = usersEntity.userName;
        _riderPhoneNumber = usersEntity.fullPhoneNumber;
        _users = convertUsersEntityToUsers(usersEntity);
        notifyListeners();
      }
    });
  }

  void _getDataFromDatabase() async {
    await _riderHomeRepository.getUserDataFromDatabase().then((value) {
      if (value.data != null) {
        _users = value.data as Users;
        _riderProfileUrl = (_users?.profileUrl)!;
        _riderName = (_users?.userName)!;
        _riderPhoneNumber = (_users?.fullPhoneNumber)!;
        notifyListeners();

        if ((_users?.currentRideId)!.isNotEmpty) {
          // todo
          Navigator.pushNamed(
            _context,
            '/rider_rides_screen',
          );
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
    _pickUpLocation = LatLng(
      _currentPosition!.latitude!,
      _currentPosition!.longitude!,
    );
    notifyListeners();
    getAddressFromPickUpMovement();
  }

  void onCameraPositionChange(LatLng location) async {
    _pickUpLocation = location;
    notifyListeners();
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

  void onAddressSelect(Object result) async {
    var prediction = result as Prediction;
    GoogleMapsPlaces googleMapsPlaces = GoogleMapsPlaces(
      apiKey: googleMapsApiKey,
    );
    PlacesDetailsResponse details = await googleMapsPlaces.getDetailsByPlaceId(
      prediction.placeId!,
    );
    _pickUpLocation = LatLng(
      (details.result.geometry?.location.lat)!,
      (details.result.geometry?.location.lng)!,
    );
    addSourcePositionMarker();
  }

  void addSourcePositionMarker() async {
    final GoogleMapController? controller = await _controller.future;
    controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _pickUpLocation,
      zoom: 16,
    )));
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _pickUpLocation,
    );
    notifyListeners();
  }

  void openCaptainVerificationPage() async {
    showLoadingDialogBox(_context);
    await _riderHomeRepository.createUserToDriver(_pickUpLocation).then((value) {
      if (value.data != null) {
        Navigator.pushNamedAndRemoveUntil(
          _context,
          '/driver_home_screen',
          (r) => false,
        );
      } else {
        Navigator.pop(_context);
      }
    });
  }

  void logoutUser() async {
    showLoadingDialogBox(_context);
    await _riderHomeRepository.logoutUserFromDevice().then((value) {
      if (value.data != null) {
        Navigator.pushNamedAndRemoveUntil(
          _context,
          '/login_screen',
          (r) => false,
        );
      } else {
        Navigator.pop(_context);
      }
    });
  }
}
