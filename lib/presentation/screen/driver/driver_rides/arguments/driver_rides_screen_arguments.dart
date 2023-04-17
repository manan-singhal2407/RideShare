import '../../../../../data/network/model/rides.dart';

class DriverRidesScreenArguments {
  final String currentRideId;
  final Rides? rides;

  DriverRidesScreenArguments(
    this.currentRideId,
    this.rides,
  );
}
