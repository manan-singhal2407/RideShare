import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_rider_my_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/rides.dart';

@Injectable(as: IRiderMyRidesRepository)
class RiderMyRidesRepository implements IRiderMyRidesRepository {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  Future<DataState> retrievePreviousRidesFromQuery() async {
    List<List<Object>> ridesList = [];
    await _firebaseFirestore
        .collection('Rides')
        .where('User1.userUid', isEqualTo: _firebaseAuth.currentUser?.uid)
        .orderBy('createdRide1At', descending: true)
        .limit(20)
        .get()
        .then((value) async {
      for (int i = 0; i < value.docs.length; i++) {
        Rides rides = Rides.fromJson(value.docs[i].data());
        if (rides.mergeRideId.isNotEmpty) {
          await _firebaseFirestore
              .collection('Rides')
              .doc(rides.mergeRideId)
              .get()
              .then((value) {
            ridesList.add([Rides.fromJson(value.data()!), rides.user1?.userUid == _firebaseAuth.currentUser?.uid]);
          });
        } else {
          ridesList.add([rides, true]);
        }
      }
    });
    return DataState.success(ridesList);
  }
}
