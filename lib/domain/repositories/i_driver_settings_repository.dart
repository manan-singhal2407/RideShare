import '../../domain/state/data_state.dart';

abstract class IDriverSettingsRepository {
  Future<DataState> getDriverStatusFromLocalDatabase();

  Future<DataState> getDriverStatusFromDatabase();

  Future<DataState> saveDriverStatusToDatabase(bool isSharingOn);
}
