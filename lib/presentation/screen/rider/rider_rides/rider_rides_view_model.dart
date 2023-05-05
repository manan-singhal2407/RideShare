import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_rider_rides_repository.dart';
import '../../../../domain/state/data_state.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';

class RiderRidesViewModel extends ChangeNotifier {
  final IRiderRidesRepository _riderRidesRepository =
      getIt<IRiderRidesRepository>();

  final BuildContext _context;
  final String _rideId;

  bool _isLoadingRideInfo = true;
  Rides? _rides;
  StreamSubscription<DataState>? _streamSubscription;
  final StreamController<DataState> _streamController =
      StreamController<DataState>.broadcast();

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final List<Marker> _screenMarker = [];

  RiderRidesViewModel(this._context, this._rideId) {
    _createContinuousConnectionWithDatabase();
  }

  bool get isLoadingRideInfo => _isLoadingRideInfo;

  Rides? get rides => _rides;

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  List<Marker> get screenMarker => _screenMarker;

  void _createContinuousConnectionWithDatabase() async {
    _riderRidesRepository.createContinuousConnectionWithDatabase(
        _rideId, _streamController);
    _streamSubscription = _streamController.stream.listen((value) async {
      if (value.data != null) {
        _rides = (value.data)[0] as Rides;
        bool isThisAUser1 = (value.data)[1] as bool;
        _isLoadingRideInfo = false;
        _screenMarker.clear();
        _screenMarker.add(Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            (_rides?.driverLatitude)!,
            (_rides?.driverLongitude)!,
          ),
          icon: BitmapDescriptor.fromBytes(
            await getUint8ListImages(
              'assets/images/swift.png',
              100,
            ),
          ),
        ));

        if (_rides?.user2 != null) {
          String mergePath = (_rides?.mergePath)!;
          _screenMarker.add(Marker(
            markerId: const MarkerId('source1'),
            position: LatLng(
              (_rides?.pickupUser1Latitude)!,
              (_rides?.pickupUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[0]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination1'),
            position: LatLng(
              (_rides?.pickupUser2Latitude)!,
              (_rides?.pickupUser2Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[1]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('source2'),
            position: LatLng(
              (_rides?.destinationUser1Latitude)!,
              (_rides?.destinationUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[2]}.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination2'),
            position: LatLng(
              (_rides?.destinationUser2Latitude)!,
              (_rides?.destinationUser2Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/ic_marker_position${mergePath[3]}.png',
                100,
              ),
            ),
          ));
          notifyListeners();
          if (mergePath == '1234') {
            if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedDestinationUser1At == 0) {
              _showPolylineForDestinationUser1();
            } else {
              _showPolylineForDestinationUser2();
            }
          } else if (mergePath == '1243') {
            if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedDestinationUser2At == 0) {
              _showPolylineForDestinationUser2();
            } else {
              _showPolylineForDestinationUser1();
            }
          } else if (mergePath == '2134') {
            if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedDestinationUser1At == 0) {
              _showPolylineForDestinationUser1();
            } else {
              _showPolylineForDestinationUser2();
            }
          } else if (mergePath == '2143') {
            if (_rides?.reachedPickupUser2At == 0) {
              _showPolylineForPickupUser2();
            } else if (_rides?.reachedPickupUser1At == 0) {
              _showPolylineForPickupUser1();
            } else if (_rides?.reachedDestinationUser2At == 0) {
              _showPolylineForDestinationUser2();
            } else {
              _showPolylineForDestinationUser1();
            }
          }
        } else {
          _screenMarker.add(Marker(
            markerId: const MarkerId('source'),
            position: LatLng(
              (_rides?.pickupUser1Latitude)!,
              (_rides?.pickupUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/pick.png',
                100,
              ),
            ),
          ));
          _screenMarker.add(Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(
              (_rides?.destinationUser1Latitude)!,
              (_rides?.destinationUser1Longitude)!,
            ),
            icon: BitmapDescriptor.fromBytes(
              await getUint8ListImages(
                'assets/images/pick.png',
                100,
              ),
            ),
          ));
          notifyListeners();
          if (_rides?.reachedPickupUser1At == 0) {
            _showPolylineForPickupUser1();
          } else {
            _showPolylineForDestinationUser1();
          }
        }

        if (isThisAUser1) {
          if (_rides?.reachedDestinationUser1At != 0) {
            // todo show feedback screen to user
          }
        } else {
          if (_rides?.reachedDestinationUser2At != 0) {
            // todo show feedback screen to user
          }
        }
        notifyListeners();
      }
    });
  }

  void _showPolylineForPickupUser1() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.pickupUser1Latitude)!,
        (_rides?.pickupUser1Longitude)!,
      ),
    ).then((value) async {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForPickupUser2() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.pickupUser2Latitude)!,
        (_rides?.pickupUser2Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForDestinationUser1() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.destinationUser1Latitude)!,
        (_rides?.destinationUser1Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void _showPolylineForDestinationUser2() async {
    await getPolylineBetweenTwoPoints(
      LatLng(
        (_rides?.driverLatitude)!,
        (_rides?.driverLongitude)!,
      ),
      LatLng(
        (_rides?.destinationUser2Latitude)!,
        (_rides?.destinationUser2Longitude)!,
      ),
    ).then((value) {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void disposeScreen() async {
    _streamSubscription?.cancel();
    _streamController.close();
  }
}
