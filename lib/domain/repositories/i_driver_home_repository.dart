import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/state/data_state.dart';

abstract class IDriverHomeRepository {
  Future<DataState> getDriverDataFromLocalDatabase();

  Future<DataState> getDriverDataFromDatabase();

  Future<DataState> updateDriverLocation(LatLng latLng);

  Future<DataState> logoutUserFromDevice();
}
