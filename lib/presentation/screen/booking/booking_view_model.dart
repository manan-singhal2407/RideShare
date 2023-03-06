import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingViewModel extends ChangeNotifier {
  final BuildContext _context;
  final LatLng _pickupLatLng;
  final LatLng _destinationLatLng;

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();
  Marker? _sourcePosition, _destinationPosition;

  BookingViewModel(
    this._context,
    this._pickupLatLng,
    this._destinationLatLng,
  ) {
    _getPolylinesBetweenSourceAndDestination();
    _getSourceAndDestinationMarker();
  }

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  void _getPolylinesBetweenSourceAndDestination() async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDschydseXpu7lOGtBorLzIzWl-rEr2a24',
      PointLatLng(_pickupLatLng.latitude, _pickupLatLng.longitude),
      PointLatLng(_destinationLatLng.latitude, _destinationLatLng.longitude),
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
    polylines[id] = polyline;
    notifyListeners();
  }

  void _getSourceAndDestinationMarker() async {
    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(24, 24),
      ),
      'assets/images/pick.png',
    ).then((icon) {
      _sourcePosition = Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
        // icon: icon,
      );
    }).onError((error, stackTrace) {
      _sourcePosition = Marker(
        markerId: const MarkerId('pickup'),
        position: _pickupLatLng,
      );
    });

    await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(48, 48),
      ),
      'assets/images/pick.png',
    ).then((icon) {
      _destinationPosition = Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLatLng,
        // icon: icon,
      );
    }).onError((error, stackTrace) {
      _destinationPosition = Marker(
        markerId: const MarkerId('destination'),
        position: _destinationLatLng,
      );
    });

    notifyListeners();
  }
}
