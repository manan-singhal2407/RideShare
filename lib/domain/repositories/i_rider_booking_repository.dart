import 'dart:async';

import '../../data/network/model/rides.dart';
import '../../domain/state/data_state.dart';

abstract class IRiderBookingRepository {
  Future<DataState> getUserDataFromLocalDatabase();

  Future<DataState> getUserDataFromDatabase();

  Future<DataState> getRideInfoFromDatabase(String rideId);

  Future<DataState> saveRideToDatabase(Rides rides);

  void createContinuousConnectionBetweenDatabase(
    String rideId,
    StreamController<DataState> streamController,
  );

  Future<DataState> sendRideRequestForSharedDriver(Rides rides);

  Future<DataState> sendRideRequestForFreeDriver(Rides rides);

  Future<DataState> cancelRideByUser(String rideId);
}
