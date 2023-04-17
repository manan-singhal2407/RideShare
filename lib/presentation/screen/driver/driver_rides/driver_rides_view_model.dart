import 'dart:async';

import 'package:btp/domain/repositories/i_driver_rides_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/cache/database/entities/driver_entity.dart';
import '../../../../data/network/model/driver.dart';
import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_driver_home_repository.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/widgets/loading.dart';

class DriverRidesViewModel extends ChangeNotifier {
  final IDriverRidesRepository _driverRidesRepository =
      getIt<IDriverRidesRepository>();

  final BuildContext _context;
  final String _currentRideId;
  final Rides? _rides;

  bool _isLoading = false;
  late Rides _ridesInfo;

  late LatLng _driverLocation = const LatLng(30.7333, 76.7794);
  Location location = Location();
  loc.LocationData? _currentPosition;
  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();
  Marker? _sourcePosition, _destinationPosition;

  String _driverProfileUrl = '';
  String _driverName = '';
  String _driverPhoneNumber = '';
  bool _driverOffline = true;

  late Timer _timer;

  DriverRidesViewModel(this._context, this._currentRideId, this._rides) {
    if (_rides == null) {
      _isLoading = true;
      _getRidesInfoFromDatabase();
    } else {
      _ridesInfo = _rides!;
      _getCurrentLocation();
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _getCurrentLocation();
      });
    }
  }

  bool get isLoading => _isLoading;

  Rides get ridesInfo => _ridesInfo;

  LatLng get driverLocation => _driverLocation;

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  String get driverProfileUrl => _driverProfileUrl;

  String get driverName => _driverName;

  String get driverPhoneNumber => _driverPhoneNumber;

  bool get driverOffline => _driverOffline;

  void _getRidesInfoFromDatabase() async {
    await _driverRidesRepository
        .getRidesInfoFromDatabase(_currentRideId)
        .then((value) {
      if (value.data != null) {
        _isLoading = false;
        _ridesInfo = value.data as Rides;
        _getCurrentLocation();
        _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
          _getCurrentLocation();
        });
        notifyListeners();
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
    _destinationPosition = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        _ridesInfo.pickupUser1Latitude,
        _ridesInfo.pickupUser1Longitude,
      ),
    );
    _getPolylinesBetweenSourceAndDestination();
  }

  void _getPolylinesBetweenSourceAndDestination() async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(_driverLocation.latitude, _driverLocation.longitude),
      PointLatLng(_ridesInfo.pickupUser1Latitude, _ridesInfo.pickupUser1Longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        points.add({'lat': point.latitude, 'lng': point.longitude});
      }
    }

    PolylineId id = const PolylineId('route');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue.withOpacity(0.8),
      points: polylineCoordinates,
      width: 4,
    );
    _polylines[id] = polyline;
    notifyListeners();
    _ridesInfo.driverLatitude = _driverLocation.latitude;
    _ridesInfo.driverLongitude = _driverLocation.longitude;
    // await _driverHomeRepository.updateDriverLocation(_driverLocation);
  }

  void onClickGoButton() async {
    _driverOffline = false;
    // _driverHomeRepository.setDriverOnline(true).then((value) {
    //   if (value.data != null) {
    //     notifyListeners();
    //     onClickNextButton();
    //   }
    // });
  }

  void onClickNextButton() async {
    Navigator.pushNamed(
      _context,
      '/driver_ride_request_screen',
    );
  }

  void onClickSetOfflineButton() async {
    _driverOffline = true;
    // _driverHomeRepository.setDriverOnline(false).then((value) {
    //   if (value.data != null) {
    //     notifyListeners();
    //   }
    // });
  }

  void logoutDriver() async {
    showLoadingDialogBox(_context);
    // _driverHomeRepository.logoutUserFromDevice().then((value) {
    //   Navigator.pushNamedAndRemoveUntil(
    //     _context,
    //     '/login_screen',
    //     (r) => false,
    //   );
    // });
  }

  void disposeScreen() async {
    _timer.cancel();
  }
}
