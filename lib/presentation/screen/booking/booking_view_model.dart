import 'dart:async';

import 'package:btp/data/network/model/rides.dart';
import 'package:btp/domain/repositories/i_booking_repository.dart';
import 'package:btp/presentation/extension/utils_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart' as direction;

import '../../base/injectable.dart';

class BookingViewModel extends ChangeNotifier {
  final IBookingRepository _bookingRepository = getIt<IBookingRepository>();

  final BuildContext _context;
  final LatLng _pickupLatLng;
  final LatLng _destinationLatLng;

  final Completer<GoogleMapController?> _controller = Completer();
  final Map<PolylineId, Polyline> _polylines = {};
  final PolylinePoints _polylinePoints = PolylinePoints();
  Marker? _sourcePosition, _destinationPosition;
  int _distanceBetweenSourceAndDestination = -100;
  bool _isCarPoolingEnabled = false;
  String? _timeTakenBetweenSourceAndDestination;

  final TextEditingController _toleranceTimeController =
      TextEditingController();

  BookingViewModel(
    this._context,
    this._pickupLatLng,
    this._destinationLatLng,
  ) {
    _getDistanceBetweenSourceAndDestination();
    _getPolylinesBetweenSourceAndDestination();
    _getSourceAndDestinationMarker();
  }

  Completer<GoogleMapController?> get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  Marker? get sourcePosition => _sourcePosition;

  Marker? get destinationPosition => _destinationPosition;

  int get distanceBetweenSourceAndDestination =>
      _distanceBetweenSourceAndDestination;

  String? get timeTakenBetweenSourceAndDestination =>
      _timeTakenBetweenSourceAndDestination;

  bool get isCarPoolingEnabled => _isCarPoolingEnabled;

  TextEditingController get toleranceTimeController => _toleranceTimeController;

  void _getDistanceBetweenSourceAndDestination() async {
    direction.GoogleMapsDirections directionsApi =
        direction.GoogleMapsDirections(
      apiKey: googleMapsApiKey,
    );
    direction.DirectionsResponse response =
        await directionsApi.directionsWithLocation(
      direction.Location(
          lat: _pickupLatLng.latitude, lng: _pickupLatLng.longitude),
      direction.Location(
          lat: _destinationLatLng.latitude, lng: _destinationLatLng.longitude),
    );
    if (response.isOkay) {
      _distanceBetweenSourceAndDestination =
          response.routes[0].legs[0].distance.value.toInt();
      _timeTakenBetweenSourceAndDestination =
          response.routes[0].legs[0].duration.text;
      notifyListeners();
    }
  }

  void _getPolylinesBetweenSourceAndDestination() async {
    List<LatLng> polylineCoordinates = [];
    List<dynamic> points = [];
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
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

  void onCarPoolingClicked() async {
    _isCarPoolingEnabled = !_isCarPoolingEnabled;
    _toleranceTimeController.text = '15';
    notifyListeners();
  }

  void onBookSwiftClicked() async {
    Rides rides = Rides(
      DateTime.now().millisecondsSinceEpoch,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      _distanceBetweenSourceAndDestination / 50,
      0,
      _distanceBetweenSourceAndDestination / 60,
      0,
      0,
      _pickupLatLng.latitude,
      _pickupLatLng.longitude,
      _destinationLatLng.latitude,
      _destinationLatLng.longitude,
      0,
      0,
      0,
      0,
      _isCarPoolingEnabled,
      false,
      false,
      int.parse(_toleranceTimeController.text)*60,
      0,
      int.parse(_toleranceTimeController.text),
      0,
      null,
      null,
      null,
    );
    // todo add request to driver and user table as well
    await _bookingRepository.requestedNewRideToDatabase(rides).then((value) {
      if (value.data != null) {

      } else {

      }
      notifyListeners();
    });
  }
}
