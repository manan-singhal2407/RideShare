import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../data/network/model/rides.dart';

class DriverRideRequestDetailScreenArguments {
  final String address;
  final String distance;
  final String timeTaken;
  final LatLng latLng;
  final Rides rides;

  DriverRideRequestDetailScreenArguments(
      this.address,
      this.distance,
      this.timeTaken,
      this.latLng,
      this.rides,
  );
}
