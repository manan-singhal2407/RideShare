import '../../domain/state/data_state.dart';

abstract class IDriverRidesRepository {
  Future<DataState> getRidesInfoFromDatabase(String rideId);
}
