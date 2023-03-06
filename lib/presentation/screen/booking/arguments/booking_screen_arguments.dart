import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingScreenArguments {
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;

  BookingScreenArguments(
    this.pickupLatLng,
    this.destinationLatLng,
  );
}
