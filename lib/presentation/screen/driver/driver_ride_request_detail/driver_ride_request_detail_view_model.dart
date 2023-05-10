import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_driver_ride_request_detail_repository.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';
import '../../../theme/color.dart';
import '../../../theme/widgets/loading.dart';
import '../driver_rides/arguments/driver_rides_screen_arguments.dart';

class DriverRideRequestDetailViewModel extends ChangeNotifier {
  final IDriverRideRequestDetailRepository _driverRideRequestDetailRepository =
      getIt<IDriverRideRequestDetailRepository>();

  final BuildContext _context;
  final LatLng _latLng;
  final Rides _rides;

  final Map<PolylineId, Polyline> _polylines = {};
  Marker? _sourcePosition, _destinationPosition;

  DriverRideRequestDetailViewModel(this._context, this._latLng, this._rides) {
    _getPolylinesAndMarker();
  }

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  void _getPolylinesAndMarker() async {
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _latLng,
      icon: BitmapDescriptor.fromBytes(
        await getUint8ListImages(
          'assets/images/ic_marker_driver.png',
          100,
        ),
      ),
    );
    _destinationPosition = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        _rides.pickupUser1Latitude,
        _rides.pickupUser1Longitude,
      ),
      icon: BitmapDescriptor.fromBytes(
        await getUint8ListImages(
          'assets/images/ic_marker_pickup.png',
          50,
        ),
      ),
    );
    notifyListeners();
    await getPolylineBetweenTwoPoints(
      _latLng,
      LatLng(_rides.pickupUser1Latitude, _rides.pickupUser1Longitude),
    ).then((value) async {
      _polylines[value.polylineId] = value;
      notifyListeners();
    });
  }

  void onAcceptRequest() async {
    showLoadingDialogBox(_context);
    await _driverRideRequestDetailRepository
        .acceptRideRequest(_rides.rideId, (_rides.user1?.userUid)!)
        .then((value) {
      Navigator.pop(_context);
      if (value.data != null) {
        Navigator.pushNamedAndRemoveUntil(
          _context,
          '/driver_rides_screen',
          ModalRoute.withName('/driver_home_screen'),
          arguments: DriverRidesScreenArguments(
            (value.data as Rides).rideId,
          ),
        );
      } else {
        Navigator.pop(_context);
        showScaffoldMessenger(
          _context,
          'This ride does not exist any more',
          errorStateColor,
        );
      }
    }).onError((error, stackTrace) {
      Navigator.pop(_context);
    });
  }

  void onRejectRequest() async {
    showLoadingDialogBox(_context);
    await _driverRideRequestDetailRepository
        .removeRejectedRideRequest(_rides.rideId, (_rides.user1?.userUid)!)
        .then((value) {
      Navigator.pop(_context);
      if (value.data != null) {
        Navigator.pop(_context);
      }
    }).onError((error, stackTrace) {
      Navigator.pop(_context);
    });
  }
}
