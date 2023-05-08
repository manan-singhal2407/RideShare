import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_driver_my_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/rides.dart';

@Injectable(as: IDriverMyRidesRepository)
class DriverMyRidesRepository implements IDriverMyRidesRepository {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> retrievePreviousRidesFromQuery() async {
    List<Rides> ridesList = [];
    await _firebaseFirestore
        .collection('Rides')
        .where('Driver.driverUid', isEqualTo: _firebaseAuth.currentUser?.uid)
        .where('isRideOver', isEqualTo: true)
        .orderBy('createdRide1At', descending: true)
        .limit(20)
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        ridesList.add(Rides.fromJson(value.docs[i].data()));
      }
    });
    return DataState.success(ridesList);
  }
}
