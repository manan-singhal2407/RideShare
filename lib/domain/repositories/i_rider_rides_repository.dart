import 'dart:async';

import '../../domain/state/data_state.dart';

abstract class IRiderRidesRepository {
  void createContinuousConnectionWithDatabase(
    String rideId,
    StreamController<DataState> streamController,
  );

  Future<DataState> updateRatingAndRemoveCurrentRideId(
    String driverUid,
    int rating,
  );
}