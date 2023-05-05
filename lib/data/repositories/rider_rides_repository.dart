import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/i_rider_rides_repository.dart';
import '../../domain/state/data_state.dart';
import '../../presentation/base/injectable.dart';
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
}
