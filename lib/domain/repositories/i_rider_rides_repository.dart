import 'dart:async';

import '../../data/network/model/rides.dart';
import '../../domain/state/data_state.dart';

abstract class IRiderRidesRepository {
  void createContinuousConnectionWithDatabase(
    String rideId,
    StreamController<DataState> streamController,
  );

  Future<DataState> updateRatingAndRemoveCurrentRideId(
    Rides rides,
    int rating,
  );
}
