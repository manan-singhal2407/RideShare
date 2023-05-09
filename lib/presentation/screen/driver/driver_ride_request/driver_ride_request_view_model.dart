import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_driver_ride_request_repository.dart';
import '../../../../domain/state/data_state.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../driver_ride_request_detail/arguments/driver_ride_request_detail_screen_arguments.dart';

class DriverRideRequestViewModel extends ChangeNotifier {
  final IDriverRideRequestRepository _driverRideRequestRepository =
      getIt<IDriverRideRequestRepository>();

  final BuildContext _context;

  late LatLng _driverLocation = defaultLatLng;
  Location location = Location();
  loc.LocationData? _currentPosition;

  StreamSubscription<DataState>? _streamSubscription;
  final StreamController<DataState> _streamController =
      StreamController<DataState>.broadcast();

  bool _isLoading = true;
  List<Rides> _ridesList = [];
  final List<List<Object>> _ridesRequestData = [];

  DriverRideRequestViewModel(this._context) {
    _getCurrentLocation();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation();
    });
    _getRideRequestFromDatabase();
  }

  LatLng get driverLocation => _driverLocation;

  bool get isLoading => _isLoading;

  List<Rides> get ridesList => _ridesList;

  List<List<Object>> get ridesRequestData => _ridesRequestData;

  void _getCurrentLocation() async {
    location.changeSettings(accuracy: loc.LocationAccuracy.high);
    _currentPosition = await location.getLocation();
    _driverLocation = LatLng(
      _currentPosition!.latitude!,
      _currentPosition!.longitude!,
    );
    notifyListeners();
  }

  void _getRideRequestFromDatabase() async {
    _driverRideRequestRepository.loadDriverRequestedRides(_streamController);
    _streamSubscription = _streamController.stream.listen((value) async {
      if (value.data != null) {
        _ridesList = value.data;
        _ridesRequestData.clear();
        for (int i = 0; i < _ridesList.length; i++) {
          await getDistanceAndTimeBetweenSourceAndDestination(
            _driverLocation,
            LatLng(
              _ridesList[i].pickupUser1Latitude,
              _ridesList[i].pickupUser1Longitude,
            ),
          ).then((value1) async {
            await getDistanceAndTimeBetweenSourceAndDestination(
              LatLng(
                _ridesList[i].pickupUser1Latitude,
                _ridesList[i].pickupUser1Longitude,
              ),
              LatLng(
                _ridesList[i].destinationUser1Latitude,
                _ridesList[i].destinationUser1Longitude,
              ),
            ).then((value2) {
              _ridesRequestData.add([
                _ridesList[i].initialFareReceivedByDriver.toDouble(),
                getMToKmFormattedNumber(value1[0]),
                getSecToTimeFormattedNumber(value1[1].toInt()),
                _ridesList[i].pickupUser1Address,
                getMToKmFormattedNumber(value2[0]),
                getSecToTimeFormattedNumber(value2[1].toInt()),
                _ridesList[i].destinationUser1Address,
              ]);
              if (_ridesRequestData.length == _ridesList.length) {
                _isLoading = false;
                notifyListeners();
              }
            });
          });
        }
      }
    });
  }

  void onSelectRide(
    String address,
    String distance,
    String timeTaken,
    Rides rides,
  ) async {
    Navigator.pushNamed(
      _context,
      '/driver_ride_request_detail_screen',
      arguments: DriverRideRequestDetailScreenArguments(
        address,
        distance,
        timeTaken,
        _driverLocation,
        rides,
      ),
    );
  }

  void disposeScreen() async {
    _streamSubscription?.cancel();
    _streamController.close();
  }
}
