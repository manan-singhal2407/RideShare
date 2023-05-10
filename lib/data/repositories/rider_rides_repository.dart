import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_rider_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
import '../network/model/driver.dart';
import '../network/model/rides.dart';
import '../network/model/users.dart';

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
    Rides rides,
    int rating,
  ) async {
    bool onSuccess = false;
    await _firebaseFirestore
        .collection('Driver')
        .doc(rides.driver?.driverUid)
        .get()
        .then((value) async {
      Driver driver = Driver.fromJson(value.data()!);
      await _firebaseFirestore
          .collection('Driver')
          .doc(rides.driver?.driverUid)
          .update({
        'driverRating': driver.driverRating + rating,
        'driverRatedRides': driver.driverRatedRides + 1
      }).then((value) async {
        await _firebaseFirestore
            .collection('Users')
            .doc(_firebaseAuth.currentUser?.uid)
            .get()
            .then((value) async {
          Users users = Users.fromJson(value.data()!);
          await _firebaseFirestore
              .collection('Users')
              .doc(_firebaseAuth.currentUser?.uid)
              .update({
            'currentRideId': '',
            'sharedRides': users.sharedRides + (rides.user2 != null ? 1 : 0),
            'totalRides': users.totalRides + 1,
            'totalFare': users.totalFare +
                (rides.user1?.userUid == _firebaseAuth.currentUser?.uid
                    ? rides.user2 != null
                        ? rides.farePriceForUser1
                        : rides.initialFareForUser1
                    : rides.farePriceForUser2),
            'totalAmountSaved': users.totalAmountSaved +
                (rides.user2 != null
                    ? (rides.user1?.userUid == _firebaseAuth.currentUser?.uid
                        ? rides.initialFareForUser1 - rides.farePriceForUser1
                        : rides.initialFareForUser2 - rides.farePriceForUser2)
                    : 0),
          }).then((value) {
            onSuccess = true;
          });
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
