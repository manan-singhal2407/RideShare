import '../../data/network/model/rides.dart';
import '../../domain/state/data_state.dart';

abstract class IBookingRepository {
  Future<DataState> requestedNewRideToDatabase(Rides rides);
}
