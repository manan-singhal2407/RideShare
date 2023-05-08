import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/state/data_state.dart';

abstract class IDriverMyRidesRepository {
  Future<DataState> retrievePreviousRidesFromQuery();
}
