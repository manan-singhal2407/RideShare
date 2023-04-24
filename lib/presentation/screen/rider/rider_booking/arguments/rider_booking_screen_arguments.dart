import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiderBookingScreenArguments {
  final bool isSharingOn;
  final int tolerance;
  final int amountNeedToSave;
  final LatLng pickupLatLng;
  final LatLng destinationLatLng;

  RiderBookingScreenArguments(
    this.isSharingOn,
    this.tolerance,
    this.amountNeedToSave,
    this.pickupLatLng,
    this.destinationLatLng,
  );
}
