import '../../domain/state/data_state.dart';

abstract class IDriverRideRequestDetailRepository {
  Future<DataState> acceptRideRequest(String rideId, String userUid);

  Future<DataState> removeRejectedRideRequest(String rideId, String userUid);
}
