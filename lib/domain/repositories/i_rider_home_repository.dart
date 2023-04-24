import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/state/data_state.dart';

abstract class IRiderHomeRepository {
  Future<DataState> getUserDataFromLocalDatabase();

  Future<DataState> getUserDataFromDatabase();

  Future<DataState> createUserToDriver(LatLng latLng);

  Future<DataState> logoutUserFromDevice();
}
