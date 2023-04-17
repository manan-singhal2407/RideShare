import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_driver_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/rides.dart';

@Injectable(as: IDriverRidesRepository)
class DriverRidesRepository implements IDriverRidesRepository {
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> getRidesInfoFromDatabase(String rideId) async {
    Rides? rides;
    await _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .get()
        .then((value) async {
      rides = Rides.fromJson(value.data()!);
    });
    return DataState.success(rides);
  }
}
