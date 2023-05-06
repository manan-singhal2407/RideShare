import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_rider_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/driver.dart';
import '../network/model/rides.dart';

@Injectable(as: IRiderRidesRepository)
class RiderRidesRepository implements IRiderRidesRepository {
  final FirebaseAuth _firebaseAuth = getIt<FirebaseAuth>();
  final FirebaseFirestore _firebaseFirestore = getIt<FirebaseFirestore>();

  @override
  void createContinuousConnectionWithDatabase(
    String rideId,
    StreamController<DataState<dynamic>> streamController,
  ) {
    _firebaseFirestore
        .collection('Rides')
        .doc(rideId)
        .snapshots()
        .listen((value) async {
      Rides rides = Rides.fromJson(value.data()!);
      streamController.add(
        DataState.success([
          rides,
          rides.user1?.userUid == _firebaseAuth.currentUser?.uid,
        ]),
      );
    });
  }

  @override
  Future<DataState> updateRatingAndRemoveCurrentRideId(
    String driverUid,
    int rating,
  ) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(driverUid)
        .get()
        .then((value) async {
      Driver driver = Driver.fromJson(value.data()!);
      await _firebaseFirestore
          .collection('Driver')
          .doc(driverUid)
          .update({'driverRating': driver.driverRating + rating, 'driverRatedRides': driver.driverRatedRides + 1})
          .then((value) async {
        await _firebaseFirestore
            .collection('Users')
            .doc(_firebaseAuth.currentUser?.uid)
            .update({'currentRideId': ''})
            .then((value) {
          onSuccess = true;
        });
      });
    });
    if (onSuccess) {
      return DataState.success(true);
    } else {
      return DataState.error(null, null);
    }
  }
}
