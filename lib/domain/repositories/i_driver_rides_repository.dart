import 'dart:async';

import '../../domain/state/data_state.dart';

abstract class IDriverRidesRepository {
  Future<DataState> getRidesInfoFromDatabase(String rideId);

  void createContinuousConnectionWithSharingRide(
    StreamController<DataState> streamController,
  );

  Future<DataState> onSelectSharedRide(
    String rideId,
    String requestRideId,
    String userUid,
  );

  Future<DataState> onCancelSharedRide(String requestRideId, String userUid);

  Future<DataState> updateRideInfo(
    String rideId,
    Map<String, Object> updateData,
    int totalFare,
    bool isRideOver,
    bool isRideShared,
  );
}
