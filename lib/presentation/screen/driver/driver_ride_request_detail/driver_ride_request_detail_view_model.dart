import 'dart:async';

import 'package:btp/presentation/screen/driver/driver_rides/arguments/driver_rides_screen_arguments.dart';
import 'package:btp/presentation/theme/color.dart';
import 'package:btp/presentation/theme/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/network/model/rides.dart';
import '../../../../domain/repositories/i_driver_ride_request_detail_repository.dart';
import '../../../base/injectable.dart';
import '../../../extension/utils_extension.dart';

class DriverRideRequestDetailViewModel extends ChangeNotifier {
  final IDriverRideRequestDetailRepository _driverRideRequestDetailRepository =
      getIt<IDriverRideRequestDetailRepository>();

  final BuildContext _context;
  final LatLng _latLng;
  final Rides _rides;

  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();
  Marker? _sourcePosition, _destinationPosition;

  DriverRideRequestDetailViewModel(this._context, this._latLng, this._rides) {
    _sourcePosition = Marker(
      markerId: const MarkerId('source'),
      position: _latLng,
    );
    _destinationPosition = Marker(
      markerId: const MarkerId('destination'),
      position: LatLng(
        _rides.pickupUser1Latitude,
        _rides.pickupUser1Longitude,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    _getPolylinesBetweenSourceAndDestination();
  }

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  void _getPolylinesBetweenSourceAndDestination() async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(_latLng.latitude, _latLng.longitude),
      PointLatLng(_rides.pickupUser1Latitude, _rides.pickupUser1Longitude),
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
            '',
            value.data as Rides,
          ),
        );
      } else {
        showScaffoldMessenger(
          _context,
          'This ride does not exist any more',
          errorStateColor,
        );
        Navigator.pop(_context);
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
