import '../../domain/state/data_state.dart';

abstract class IDriverRideRequestDetailRepository {
  Future<DataState> acceptRideRequest(String rideId);

  Future<DataState> removeRejectedRideRequest(String rideId);
}
