import 'dart:async';

import '../../domain/state/data_state.dart';

abstract class IDriverRideRequestRepository {
  void loadDriverRequestedRides(StreamController<DataState> streamController);
}
